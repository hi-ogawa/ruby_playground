require_relative '../../lib/hiogawa_playground/tsp'

describe HiogawaPlayground::Tsp do
  Tsp = HiogawaPlayground::Tsp

  before(:all) do
    #    +----------+
    #  4 | . .    . |
    #  3 |       .  |
    #  2 |  ..      |
    #  1 |          |
    #  0 |.     .  .|
    #    +----------+
    #     0123456789

    @points = [
      [0, 0],
      [1, 4],
      [2, 2],
      [3, 2],
      [3, 4],
      [6, 0],
      [7, 3],
      [8, 4],
      [9, 0]
    ]
    @distance_function = lambda do |i, j|
      p = @points[i]
      q = @points[j]
      Math.sqrt((p[0] - q[0])**2 + (p[1] - q[1])**2)
    end
  end

  describe 'self.solve_tour' do
    it '' do
      tour = [0, 2, 1, 4, 3, 6, 7, 8, 5, 0]
      expect(Tsp.solve_tour(@points, @distance_function)).to eq(tour)
    end

    describe 'when points.length == 0' do
      it 'is not working' do
        expect(Tsp.solve_tour([], nil)).to eq([0])
      end
    end
  end

  describe 'self.solve_path' do
    describe 'with different start/end' do
      it '' do
        path = [1, 4, 2, 0, 3, 5, 8, 7, 6]
        expect(Tsp.solve_path(@points, @distance_function, 1, 6)).to eq(path)
      end
    end

    describe 'with same start/end' do
      it '' do
        path = [1, 4, 6, 7, 8, 5, 3, 2, 0, 1]
        expect(Tsp.solve_path(@points, @distance_function, 1, 1)).to eq(path)
      end
    end

    describe 'when points.length == 0' do
      it 'is not working' do
        expect(Tsp.solve_path([], nil, nil, nil)).to eq([nil, nil])
      end
    end
  end

  describe 'self.solve_arbitrary_path' do
    it '' do
      path = [0, 2, 1, 4, 3, 6, 7, 8, 5]
      expect(Tsp.solve_arbitrary_path(@points, @distance_function)).to eq(path)
    end

    describe 'when points.length == 0' do
      it 'is not working' do
        expect { Tsp.solve_arbitrary_path([], nil) }.to raise_error(NoMethodError)
      end
    end
  end

  describe 'self.solve_path_with_loose_end' do
    it '' do
      path = [3, 2, 0, 1, 4, 7, 6, 5, 8]
      expect(
        Tsp.solve_path_with_loose_end(@points, @distance_function, 3)
      ).to eq(path)
    end

    describe 'when points.length == 0' do
      it 'is not working' do
        expect(Tsp.solve_path_with_loose_end([], nil, nil)).to eq([nil])
      end
    end
  end

  describe 'self.candidate_index_pairs' do
    it '' do
      path = [0, 1, 2, 3, 4, 5]
      pairs = [[0, 2], [1, 3], [2, 4], [0, 3], [1, 4], [0, 4]]
      expect(Tsp.candidate_index_pairs(path)).to eq(pairs)
    end
  end

  describe 'self.candidate_index_pairs_with_loose_end' do
    it '' do
      path = [0, 1, 2, 3, 4, 5]
      pairs = [
        [0, 2], [1, 3], [2, 4], [3, 5], [0, 3],
        [1, 4], [2, 5], [0, 4], [1, 5], [0, 5]
      ]
      expect(Tsp.candidate_index_pairs_with_loose_end(path)).to eq(pairs)
    end
  end

  describe 'self.two_swap' do
    describe 'usual case' do
      it '' do
        path =         [0, 1, 2, 3, 4, 5, 6]
        swapped_path = [0, 1, 4, 3, 2, 5, 6]
        expect(Tsp.two_swap(path, 1, 4)).to eq(swapped_path)
      end
    end

    describe 'loose end case' do
      it '' do
        path =         [0, 1, 2, 3, 4, 5, 6]
        swapped_path = [0, 1, 2, 6, 5, 4, 3]
        expect(Tsp.two_swap(path, 2, 6)).to eq(swapped_path)
      end
    end
  end
end
