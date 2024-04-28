class Scorekeeper
  def initialize
    @frame_scores = []
  end

  def score_list(scores_by_roll)
    detailed_frames_by_roll = Hash.new

    scores_by_roll.each do |score|
      key = detailed_frames_by_roll.keys.last || 1
      is_empty_key = detailed_frames_by_roll[key].nil?

      if score == 'X'
        detailed_frames_by_roll[is_empty_key ? key : key + 1] = score
        next
      end

      if is_empty_key
        detailed_frames_by_roll[key] = [score]
        next
      end

      if (detailed_frames_by_roll[key].is_a?(Array) && 
            detailed_frames_by_roll[key].count == 1)
        detailed_frames_by_roll[key].push(score)
      else
        detailed_frames_by_roll[key + 1] = [score]
      end
    end

    detailed_frames_by_roll.keys.each_with_index do |frame_key, i|
      frame_by_roll = detailed_frames_by_roll[frame_key]
      if frame_by_roll === 'X'
        x_value = detailed_frames_by_roll.keys.last == frame_key ? nil : frame_by_roll

        @frame_scores.push(x_value)
      else
        is_spare = frame_by_roll[1] == '/'
        frame_total = 10 if is_spare

        if (is_spare && 
              i == detailed_frames_by_roll.count - 1 && 
                detailed_frames_by_roll.count < 10)
          @frame_scores.push(nil)
          next
        end

        if frame_total.nil?
          frame_total = frame_by_roll.count == 2 ? frame_by_roll.sum : nil
        end

        if @frame_scores[i - 1] == 'X' 
          backfill_strike_scores(i, 1, frame_by_roll.first, frame_total)
        end
        
        if ([frame_total, @frame_scores[i - 1]].compact.count == 2 && 
              detailed_frames_by_roll[frame_key - 1][1] == '/')
          @frame_scores[i - 1] = @frame_scores[i - 1] + frame_by_roll.first
        end
        
        @frame_scores.push(frame_total)
      end
    end

    @frame_scores
  end

  def backfill_strike_scores(current_index, previous_index, first_roll, frame_total)
    case previous_index
    when 1
      @frame_scores[current_index - previous_index] = frame_total.nil? ? nil : 10 + frame_total

      backfill_strike_scores(current_index, 2, first_roll, frame_total) if 
        @frame_scores[current_index - 2] == 'X'
    when 2
      @frame_scores[current_index - 2] = 20 + first_roll

      backfill_strike_scores(current_index, 3, first_roll, frame_total) if 
        @frame_scores[current_index - 3] == 'X'
    when 3
      @frame_scores[current_index - 3] = 30
    end
  end
end
