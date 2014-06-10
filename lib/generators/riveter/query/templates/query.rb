<% module_namespacing do -%>
class <%= class_name %>Query < Riveter::Query::Base

  # TODO: optionally provide methods here for additional
  # results such as summaries, aggregated data or other
  # associated data

protected

  def build_relation(filter)
    # start with a relation
    relation = <%= class_name %>.all

    #
    # TODO: apply conditions etc to the query using the filter
    #
    # E.g.
    #
    # :.name filter
    #
    # relation = relation.where?(filter.name_like.present?, 'name LIKE ?', filter.name_like)
    #
    # :. page filter
    # relation.page(filter.page)
    #

    relation
  end

end
<% end -%>
