(function() {
  var bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; };

  window.spinkitButton = (function() {
    function spinkitButton(args) {
      this.stop = bind(this.stop, this);
      this.start = bind(this.start, this);
      this.init = bind(this.init, this);
      this.spinnerTemplate = bind(this.spinnerTemplate, this);
      this.options = args;
      this.el = this.options.el;
      this.width = this.el.outerWidth();
      this.text = this.el.find('span.sk-text');
      this.template = this.spinnerTemplate();
      this.spinner = $("<div />", {
        "class": "sk-spinner sk-spinner-three-bounce",
        html: this.template
      });
      this.init();
    }

    spinkitButton.prototype.spinnerTemplate = function() {
      return "<div class='sk-bounce1'></div>\n<div class='sk-bounce2'></div>\n<div class='sk-bounce3'></div>";
    };

    spinkitButton.prototype.init = function() {
      if ($(".sk-spinner")[0]) {
        this.stop($(".sk-spinner"));
      }
      return this.start();
    };

    spinkitButton.prototype.start = function() {
      this.el.css({
        "min-width": this.width
      });
      this.text.hide();
      this.el.append(this.spinner);
      return this.active = true;
    };

    spinkitButton.prototype.stop = function(el) {
      el.css({
        "min-width": "auto"
      });
      $('span.sk-text').show();
      return $(".sk-spinner").remove();
    };

    return spinkitButton;

  })();

}).call(this);
