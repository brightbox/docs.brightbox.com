# 
#  countdown.coffee
#  brightbox.com
#  
#  Created by Caius Durling on 2011-09-19.
#  Copyright 2011 Brightbox Ltd. All rights reserved.
# 

$ = jQuery
$.fn.countdown_to_launch = ->
  divmod = (total, divisor) ->
    q = Math.floor(total/divisor)
    r = total - (q*divisor)
    [q, r]

  now_date = new Date # Today
  end_date = new Date(2011, 09, 10) # 10th of October (January = 0)

  amount = (end_date - now_date) / 1000 # Seconds betwixt now and end

  delims = [["sec", 60], ["min", 60], ["hour", 24], ["day", 7]]
  output = {}
  for j in delims

    i = j[1]
    if amount >= i && j[0] != "day"
      [amount, other] = divmod(amount, i)
      r = other
    else
      r = amount
      amount = 0

    output[j[0]] = r

  # console.log(output)

  template = "%day%<span>:</span>%hour%<span>:</span>%min%<span>:</span>%sec%"
  for key, value of output
    value = Math.floor(value)
    value = "0#{value}" if value < 10
    value = 0 if value < 0
    template = template.replace "%#{key}%", value

  $("#launch time").html(template)
