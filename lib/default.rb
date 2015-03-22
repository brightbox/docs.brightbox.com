# All files in the 'lib' directory will be loaded
# before nanoc starts compiling.
require "yaml"

def clear
  '<div class="clear">.</div>'
end

def back_to_top
  '<a href="#top" class="back_to_top">&uarr; Back to top</a>'
end

def random_text
  "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Integer ac posuere dolor. Donec consectetur rhoncus porta. Praesent vulputate interdum tempor. Pellentesque et arcu a libero congue sodales. Donec nunc erat, ullamcorper et congue quis, adipiscing vel massa. Proin a dui libero, ut mattis diam. Etiam eros metus, rhoncus nec adipiscing eget, vulputate id leo. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Pellentesque dui neque, commodo sed accumsan quis, porttitor in turpis. Aenean suscipit tellus vel ligula lacinia pharetra. Sed sit amet dui id ante bibendum malesuada in eget eros. Maecenas eget massa metus."
end
