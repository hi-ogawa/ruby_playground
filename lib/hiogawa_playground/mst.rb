module HiogawaPlayground
  module Mst
    class << self
      # points: array of nodes
      # distance: distance function
      def solve(points, distance) # O(n * n)
        num_points = points.length
        parents_relation = Array.new(num_points)
        candidates = []

        # Procedure:
        #   1. init `candidates` based on `points[0]`
        #   2. loop until there's no `candidates`
        #     a. pick closest `candidates`
        #     b. update `candidates` and `parents_relation` with picked one
        #   3. return `parents_relation`

        # 1
        (1..(num_points - 1)).each do |idx|
          candidates.push([idx, 0])
        end

        # 2
        while !candidates.empty? # O(n)
          # a
          picked_pair, *rest_candidates = candidates
          rest_candidates.each do |pair| # O(n)
            if (
              distance.call(pair[0], pair[1]) <
              distance.call(picked_pair[0], picked_pair[1])
            )
              picked_pair = pair
            end
          end

          # b
          candidates.delete(picked_pair) # O(n)
          parents_relation[picked_pair[0]] = picked_pair[1]
          candidates.each do |pair| # O(n)
            if (
              distance.call(pair[0], picked_pair[0]) <
              distance.call(pair[0], pair[1])
            )
              pair[1] = picked_pair[0]
            end
          end
        end

        # 3
        parents_relation
      end

      def solve_edges(points, distance)
        solve(points, distance)
          .each_with_index
          .select { |parent, _| parent != nil }
          .map { |parent, i| [parent, i] }
      end

      # TODO: estimate time complexity
      def solve_clustering(points, distance, threshold)
        edges = solve_edges(points, distance).select { |i, j| distance.call(i, j) <= threshold }
        adjacency_list = (0..(points.length - 1)).map { |i| [i] }
        edges.each do |i, j|
          adjacency_list[i].push(j)
          adjacency_list[j].push(i)
        end

        connected_components(points.length, adjacency_list)
      end

      def connected_components(num_vs, adjacency_list)
        visited = (0..(num_vs - 1)).map { false }

        dfs = lambda do |i, current_cluster|
          current_cluster.push(i)
          visited[i] = true
          adjacency_list[i].each do |j|
            dfs.call(j, current_cluster) unless visited[j]
          end
        end

        clusters = []
        (0..(num_vs - 1)).each do |i|
          unless visited[i]
            cluster = []
            dfs.call(i, cluster)
            clusters.push(cluster)
          end
        end
        clusters
      end
    end
  end
end
