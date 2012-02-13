(function() {

  (function($) {
    return $.widget("ui.omnipost", {
      _create: function() {
        var collapse, post, text,
          _this = this;
        collapse = $("<img alt='x' title='x' id='ui-omniPostCollapse'>");
        collapse.attr('src', 'http://officeimg.vo.msecnd.net/en-us/images/MB900432537.jpg');
        text = $("<textarea id='ui-omniPostText'></textarea>");
        text.autoResize({
          extraSpace: 50
        }).addClass('ui-omniPost');
        this.element.append(collapse);
        this.element.append(text);
        this.element.append($('<br/>'));
        post = $("<button id='ui-omniPostSubmit'>Post</button>");
        this.element.append(post);
        this.element.addClass('ui-omniPost');
        this.element.focusin(function() {
          if (!text.attr('readonly')) {
            post.show();
            collapse.show();
            if (text.height() < 50) text.height(50);
          }
          text.removeClass('ui-omniPostActive');
          if (text.val() === _this.element.attr('title')) return text.text('');
        });
        collapse.click(function() {
          post.hide();
          text.text(_this.element.attr('title'));
          text.addClass('ui-omniPostActive');
          text.height(28);
          return collapse.hide();
        }).click();
        return this.element.focusout(function() {
          if (text.val() === '') return collapse.click();
        });
      },
      destroy: function() {
        return this.element.remove();
      },
      _setOption: function(option, value) {
        return $.Widget.prototype._setOption.apply(this, arguments);
      }
    });
  })(jQuery);

}).call(this);
