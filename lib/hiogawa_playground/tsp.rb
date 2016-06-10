module HiogawaPlayground
  module Tsp
    class << self
      def solve_tour(points, distance)
        n = points.length
        init_path = (0..(n - 1)).to_a.push(0)
        two_opt(distance, init_path)
      end

      def solve_path(points, distance, st_idx, end_idx)
        n = points.length
        init_path = [st_idx] +
                    (0..(n - 1)).to_a.select { |i| i != st_idx && i != end_idx } +
                    [end_idx]
        two_opt(distance, init_path)
      end

      def solve_arbitrary_path(points, distance)
        path = solve_tour(points, distance)
        n = points.length
        longest_i = (0..(n - 1)).max_by { |i| distance.call(path[i], path[i + 1]) }
        path[(longest_i + 1)..-2] + path[0..longest_i]
      end

      def solve_path_with_loose_end(points, distance, st_idx)
        n = points.length
        init_path = [st_idx] + (0..(n - 1)).to_a.select { |i| i != st_idx }
        two_opt_with_loose_end(distance, init_path)
      end

      # 2-opt algorithm
      def two_opt(distance, path)
        loop do
          opt = nil
          candidate_index_pairs(path).each do |i, j|
            before = distance.call(path[i], path[i + 1]) + distance.call(path[j], path[j + 1])
            after = distance.call(path[i], path[j]) + distance.call(path[i + 1], path[j + 1])
            if after < before
              opt = [i, j]
              break
            end
          end
          break unless opt
          path = two_swap(path, opt[0], opt[1])
        end
        path
      end

      # 2-opt algorithm extended to loose path end
      def two_opt_with_loose_end(distance, path)
        loop do
          opt = nil
          candidate_index_pairs_with_loose_end(path).each do |i, j|
            if j + 1 == path.length
              before = distance.call(path[i], path[i + 1])
              after = distance.call(path[i], path[j])
            else
              before = distance.call(path[i], path[i + 1]) + distance.call(path[j], path[j + 1])
              after = distance.call(path[i], path[j]) + distance.call(path[i + 1], path[j + 1])
            end
            if after < before
              opt = [i, j]
              break
            end
          end
          break unless opt
          path = two_swap(path, opt[0], opt[1])
        end
        path
      end

      # enumerate possible 2 points to swap
      def candidate_index_pairs(path)
        n = path.length
        (2..(n - 2)).flat_map do |gap|
          (0..(n - gap - 2)).map do |i|
            [i, i + gap]
          end
        end
      end

      def candidate_index_pairs_with_loose_end(path)
        n = path.length
        (2..(n - 1)).flat_map do |gap|
          (0..(n - gap - 1)).map do |i|
            [i, i + gap]
          end
        end
      end

      # 2 points swap operation with assuming
      #   - i + 2 <= j
      #   - j < path.length
      def two_swap(path, i, j)
        path[0..i] + path[(i + 1)..j].reverse + path[(j + 1)..-1]
      end
    end
  end
end
