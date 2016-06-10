require_relative '../../lib/hiogawa_playground/mst'

describe HiogawaPlayground::Mst do
  Mst = HiogawaPlayground::Mst

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

  describe '#solve' do
    it '' do
      parents_relation = [nil, 4, 0, 2, 3, 3, 5, 6, 5]
      expect(Mst.solve(@points, @distance_function)).to eq(
        parents_relation
      )
    end

    describe 'when points.length = 0' do
      it '' do
        expect(Mst.solve([], nil)).to eq([])
      end
    end
  end

  describe '#solve_edges' do
    it '' do
      edges = [[4, 1], [0, 2], [2, 3], [3, 4], [3, 5], [5, 6], [6, 7], [5, 8]]
      expect(Mst.solve_edges(@points, @distance_function)).to eq(edges)
    end

    describe 'when points.length = 0' do
      it '' do
        expect(Mst.solve_edges([], nil)).to eq([])
      end
    end
  end

  describe '#solve_clustering' do
    describe 'case 0' do
      it '' do
        clusters = [[0, 2, 3, 4, 1], [5, 8], [6, 7]]
        expect(
          Mst.solve_clustering(@points, @distance_function, 3)
        ).to eq(clusters)
      end
    end

    describe 'case 1' do
      it '' do
        points = [
          [0, 0],
          [1, 1]
        ]
        distance_function = lambda do |i, j|
          p = points[i]
          q = points[j]
          Math.sqrt((p[0] - q[0])**2 + (p[1] - q[1])**2)
        end
        expect(
          Mst.solve_clustering(points, distance_function, 1)
        ).to eq([[0], [1]])
      end
    end

    describe 'when points.length = 0' do
      it '' do
        expect(Mst.solve_clustering([], nil, nil)).to eq([])
      end
    end
  end

  describe '#connected_components' do
    it '' do
      adjacency_list = [
        [0, 2],
        [1, 4],
        [2, 0, 3],
        [3, 2, 4],
        [4, 1, 3],
        [5, 8],
        [6, 7],
        [7, 6],
        [8, 5]
      ]
      expect(Mst.connected_components(9, adjacency_list)).to eq(
        [[0, 2, 3, 4, 1], [5, 8], [6, 7]]
      )
    end
  end
end
