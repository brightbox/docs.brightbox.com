include Nanoc3::Helpers::Rendering
include Nanoc3::Helpers::Tagging
include Nanoc3::Helpers::Capturing
include Nanoc3::Helpers::LinkTo
include Nanoc3::Helpers::Breadcrumbs
include Nanoc3::Helpers::Blogging
# This *has* to come after Blogging is included
include ExtendBlogging
include PaginationLinks

include Nanoc3::Helpers::XMLSitemap
