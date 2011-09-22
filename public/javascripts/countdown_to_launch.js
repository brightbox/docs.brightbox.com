(function() {
  var $;
  $ = jQuery;
  $.fn.countdown_to_launch = function() {
    var amount, delims, divmod, end_date, i, j, key, now_date, other, output, r, template, value, _i, _len, _ref;
    divmod = function(total, divisor) {
      var q, r;
      q = Math.floor(total / divisor);
      r = total - (q * divisor);
      return [q, r];
    };
    now_date = new Date;
    end_date = new Date(2011, 09, 01);
    amount = (end_date - now_date) / 1000;
    delims = [["sec", 60], ["min", 60], ["hour", 24], ["day", 7]];
    output = {};
    for (_i = 0, _len = delims.length; _i < _len; _i++) {
      j = delims[_i];
      i = j[1];
      if (amount >= i && j[0] !== "day") {
        _ref = divmod(amount, i), amount = _ref[0], other = _ref[1];
        r = other;
      } else {
        r = amount;
        amount = 0;
      }
      output[j[0]] = r;
    }
    template = "%day%<span>:</span>%hour%<span>:</span>%min%<span>:</span>%sec%";
    for (key in output) {
      value = output[key];
      value = Math.floor(value);
      if (value < 10) {
        value = "0" + value;
      }
      if (value < 0) {
        value = 0;
      }
      template = template.replace("%" + key + "%", value);
    }
    return $("#launch time").html(template);
  };
}).call(this);
