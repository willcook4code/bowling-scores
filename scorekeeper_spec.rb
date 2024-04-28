require_relative 'scorekeeper'

RSpec.describe Scorekeeper do
  describe '#score_list' do
    it 'returns the total score for each frame' do
      scorekeeper = Scorekeeper.new
      result = scorekeeper.score_list([3, 6, 4, 1])
      expect(result).to match_array([9, 5])
    end
    
    it 'returns nil for uncalculated strikes' do
      scorekeeper = Scorekeeper.new
      result = scorekeeper.score_list([3, 6, 4, 1, 'X'])
      expect(result).to match_array([9, 5, nil])
    end

    it 'calculates strike values when the next frame is completed' do
      scorekeeper = Scorekeeper.new
      result = scorekeeper.score_list([3, 6, 4, 1, 'X', 5, 2])
      expect(result).to match_array([9, 5, 17, 7])
    end

    it 'returns nil for frames in progress' do
      scorekeeper = Scorekeeper.new
      result = scorekeeper.score_list([3, 6, 4, 1, 5])
      expect(result).to match_array([9, 5, nil])
    end

    it 'returns nil for both frames in progress and strikes not calculated as a result' do
      scorekeeper = Scorekeeper.new
      result = scorekeeper.score_list([3, 6, 4, 1, 'X', 5])
      expect(result).to match_array([9, 5, nil, nil])
    end
    
    it 'calculates double strikes as expected' do
      scorekeeper = Scorekeeper.new
      result = scorekeeper.score_list([3, 6, 4, 1, 'X', 'X', 5, 3])
      expect(result).to match_array([9, 5, 25, 18, 8])
    end

    it 'calculates turkeys as expected' do
      scorekeeper = Scorekeeper.new
      result = scorekeeper.score_list([3, 6, 4, 1, 'X', 'X', 'X', 2, 3])
      expect(result).to match_array([9, 5, 30, 22, 15, 5])
    end
    
    it 'calculates inconsistent strikes as expected' do
      scorekeeper = Scorekeeper.new
      result = scorekeeper.score_list([3, 6, 'X', 4, 1, 'X', 'X', 2, 3])
      expect(result).to match_array([9, 15, 5, 22, 15, 5])
    end

    it 'calculates spares as expected' do
      scorekeeper = Scorekeeper.new
      result = scorekeeper.score_list([3, '/', 4, 1, 3, 3])
      expect(result).to match_array([14, 5, 6])
    end

    it 'returns nil for frames with a spare in progress' do
      scorekeeper = Scorekeeper.new
      result = scorekeeper.score_list([4, 1, 3, '/'])
      expect(result).to match_array([5, nil])
    end
    
    it 'calculates a combination of strikes and spares as expected' do
      scorekeeper = Scorekeeper.new
      result = scorekeeper.score_list([3, 6, 'X', 3, '/', 4, 1, 3, 3])
      expect(result).to match_array([9, 20, 14, 5, 6])
    end
  end
end
