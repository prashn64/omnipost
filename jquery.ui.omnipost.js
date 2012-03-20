(function() {
  var __bind = function(fn, me){ return function(){ return fn.apply(me, arguments); }; },
    __hasProp = Object.prototype.hasOwnProperty,
    __extends = function(child, parent) { for (var key in parent) { if (__hasProp.call(parent, key)) child[key] = parent[key]; } function ctor() { this.constructor = child; } ctor.prototype = parent.prototype; child.prototype = new ctor; child.__super__ = parent.prototype; return child; };

  (function($, window, document) {
    var LinkPanel, Panel, Plugin, defaults, pluginName;
    pluginName = 'omnipost';
    defaults = {
      property: 'value'
    };
    Panel = (function() {

      function Panel(id, iconSrc, collapseSrc) {
        this.id = id;
        this.iconSrc = iconSrc;
        this.collapseSrc = collapseSrc;
        this.hide = __bind(this.hide, this);
        this.show = __bind(this.show, this);
        this.addPanelToContainer = __bind(this.addPanelToContainer, this);
        this.init = __bind(this.init, this);
        this.init();
      }

      Panel.prototype.init = function() {
        this.panelcontainer = $("<div id=" + this.id + "></div>");
        this.linkBox = $("<textarea id='ui-omniPostLink'></textarea>");
        this.linkBox.height(25);
        this.linkBox.width(500);
        this.linkIcon = $("<img src = " + this.iconSrc + " alt = 'attach'>");
        return this.panelcontainer.append(this.linkBox);
      };

      Panel.prototype.addPanelToContainer = function(container) {
        return container.append(this.panelcontainer);
      };

      Panel.prototype.show = function() {
        return this.panelcontainer.show();
      };

      Panel.prototype.hide = function() {
        return this.panelcontainer.hide();
      };

      return Panel;

    })();
    LinkPanel = (function(_super) {

      __extends(LinkPanel, _super);

      function LinkPanel() {
        LinkPanel.__super__.constructor.apply(this, arguments);
      }

      LinkPanel.prototype.init = function() {
        var attachedImage,
          _this = this;
        LinkPanel.__super__.init.apply(this, arguments).init();
        attachedImage = $("<img src = '' alt = 'attach'>");
        this.panelcontainer.append(attachedImage);
        return this.linkBox.change(function() {
          return attachedImage.attr('src', _this.linkBox.val());
        });
      };

      return LinkPanel;

    })(Panel);
    return Plugin = (function() {

      function Plugin(element, options) {
        this.element = element;
        this.options = $.extend({}, defaults, options);
        this._defaults = defaults;
        this._name = 'tagbox';
        this.init();
      }

      Plugin.prototype.init = function() {
        var collapse, link, linkPanel, post, selectedImageLink, text,
          _this = this;
        linkPanel = new LinkPanel('ui-linkBox', 'http://b.dryicons.com/images/icon_sets/coquette_part_2_icons_set/png/128x128/attachment.png', 'http://officeimg.vo.msecnd.net/en-us/images/MB900432537.jpg');
        collapse = $("<img alt='x' title='x' id='ui-omniPostCollapse'>");
        collapse.attr('src', 'http://officeimg.vo.msecnd.net/en-us/images/MB900432537.jpg');
        link = $("<img alt='a' title='attach a link' id='ui-omniPostAttach'>");
        link.attr('src', 'http://b.dryicons.com/images/icon_sets/coquette_part_2_icons_set/png/128x128/attachment.png');
        text = $("<textarea id='ui-omniPostText'></textarea>");
        text.autoResize({
          extraSpace: 50
        }).addClass('ui-omniPost');
        selectedImageLink = $("<img alt='x' title='your linked image' id='ui-omniPostImage'>");
        selectedImageLink.hide();
        $(this.element).append(collapse);
        $(this.element).append(link);
        $(this.element).append(text);
        linkPanel.addPanelToContainer($(this.element));
        linkPanel.hide();
        $(this.element).append(selectedImageLink);
        $(this.element).append($('<br/>'));
        post = $("<button id='ui-omniPostSubmit'>Post</button>");
        $(this.element).append(post);
        $(this.element).addClass('ui-omniPost');
        $(this.element).focusin(function() {
          if (!text.attr('readonly')) {
            post.show();
            collapse.show();
            link.show();
            if (text.height() < 50) text.height(50);
          }
          text.removeClass('ui-omniPostActive');
          if (text.val() === $(_this.element).attr('title')) return text.val('');
        });
        collapse.click(function() {}).click();
        $(this.element).focusout(function() {
          if (text.val() === '') return collapse.click();
        });
        return link.click(function() {
          return linkPanel.show();
        });
      };

      Plugin.prototype.destroy = function() {
        return $(this.element).remove();
      };

      Plugin.prototype._setOption = function(option, value) {
        return $.Widget.prototype._setOption.apply(this, arguments);
      };

      $.fn[pluginName] = function(options) {
        return this.each(function() {
          if (!$.data(this, "plugin_" + pluginName)) {
            return $.data(this, "plugin_" + pluginName, new Plugin(this, options));
          }
        });
      };

      return Plugin;

    })();
  })(jQuery, window, document);

}).call(this);
