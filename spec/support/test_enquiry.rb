require_relative 'test_query_filter'
require_relative 'test_query'

class TestEnquiry < Riveter::Enquiry::Base
  filter_with TestQueryFilter
  query_with TestQuery
end
