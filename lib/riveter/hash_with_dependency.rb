module Riveter
  # See http://ruby-doc.org/stdlib-2.0/libdoc/tsort/rdoc/TSort.html for details
  class HashWithDependency < Hash
    include TSort

    alias tsort_each_node each_key

    def tsort_each_child(node, &block)
      fetch(node).each(&block)
    end
  end
end
