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
        this.remove = __bind(this.remove, this);
        this.isEmpty = __bind(this.isEmpty, this);
        this.hide = __bind(this.hide, this);
        this.show = __bind(this.show, this);
        this.addPanelToContainer = __bind(this.addPanelToContainer, this);
        this.init = __bind(this.init, this);
        this.init();
      }

      Panel.prototype.init = function() {
        var _this = this;
        this.panelcontainer = $("<div class=" + this.id + "></div>");
        this.linkbox = $("<textarea class='ui-omniPostLink'></textarea>");
        this.linkIcon = $("<img class = 'ui-panelicon' src = " + this.iconSrc + " alt = 'attach'>");
        this.collapseIcon = $("<img class = 'ui-panelcollapseicon' src = " + this.collapseSrc + " alt = 'collapse'>");
        this.submitLink = $("<button class='ui-submitLink'>Add</button>");
        this.panelcontainer.append(this.linkIcon);
        this.panelcontainer.append(this.linkbox);
        this.panelcontainer.append(this.submitLink);
        this.panelcontainer.append(this.collapseIcon);
        return this.collapseIcon.click(function() {
          return _this.hide();
        });
      };

      Panel.prototype.addPanelToContainer = function(container) {
        return container.append(this.panelcontainer);
      };

      Panel.prototype.show = function() {
        return this.panelcontainer.show();
      };

      Panel.prototype.hide = function() {
        this.linkbox.val('');
        this.linktosite.text('');
        return this.panelcontainer.hide();
      };

      Panel.prototype.isEmpty = function() {
        return this.linkbox.val() === '';
      };

      Panel.prototype.remove = function() {
        return this.panelcontainer.remove();
      };

      return Panel;

    })();
    LinkPanel = (function(_super) {

      __extends(LinkPanel, _super);

      function LinkPanel() {
        this.content = __bind(this.content, this);
        this.hide = __bind(this.hide, this);
        LinkPanel.__super__.constructor.apply(this, arguments);
      }

      LinkPanel.prototype.init = function() {
        var _this = this;
        LinkPanel.__super__.init.apply(this, arguments).init();
        this.displayedContent = 'none';
        this.attachedImage = $("<img src = '' alt = 'attach'>");
        this.linktosite = $("<a href = " + (this.linkbox.val()) + " class = 'ui-linkToSite'></a>");
        this.panelcontainer.append(this.attachedImage);
        this.panelcontainer.append(this.linktosite);
        this.linkbox.change(function() {
          _this.displayedContent = 'image';
          _this.attachedImage.show();
          _this.linktosite.text('');
          return _this.attachedImage.attr('src', _this.linkbox.val());
        });
        return $(document).ready(function() {
          return _this.attachedImage.error(function() {
            _this.attachedImage.hide();
            if (_this.attachedImage.attr('src') !== '') {
              _this.displayedContent = 'link';
              _this.linktosite.attr('href', _this.linkbox.val());
              _this.linktosite.text(_this.linkbox.val());
              if (_this.linktosite.text().indexOf("http://") !== 0) {
                return _this.linktosite.attr('href', 'http://' + _this.linktosite.attr('href'));
              }
            }
          });
        });
      };

      LinkPanel.prototype.hide = function() {
        LinkPanel.__super__.hide.apply(this, arguments).hide();
        return this.attachedImage.attr('src', '');
      };

      LinkPanel.prototype.content = function() {
        if (this.displayedContent === 'image') {
          return this.attachedImage;
        } else if (this.displayedContent === 'link') {
          return this.linktosite;
        } else {
          return null;
        }
      };

      return LinkPanel;

    })(Panel);
    return Plugin = (function() {

      function Plugin(element, options) {
        this.element = element;
        this.createcompletepost = __bind(this.createcompletepost, this);
        this.options = $.extend({}, defaults, options);
        this._defaults = defaults;
        this._name = 'tagbox';
        this.init();
      }

      Plugin.prototype.init = function() {
        var collapse, link, linkPanel, post, selectedImageLink, text,
          _this = this;
        linkPanel = new LinkPanel('ui-linkbox', 'http://b.dryicons.com/images/icon_sets/coquette_part_2_icons_set/png/128x128/attachment.png', 'http://officeimg.vo.msecnd.net/en-us/images/MB900432537.jpg');
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
          return text.removeClass('ui-omniPostActive');
        });
        collapse.click(function() {
          post.hide();
          text.val($(_this.element).attr('title'));
          text.addClass('ui-omniPostActive');
          text.height(28);
          collapse.hide();
          link.hide();
          return linkPanel.hide();
        }).click();
        link.click(function() {
          return linkPanel.show();
        });
        return post.click(function() {
          var linkedcontent, textcontent;
          if (text.val() !== '' || !linkPanel.isEmpty()) {
            post.remove();
            textcontent = text.val();
            text.remove();
            linkedcontent = linkPanel.content();
            linkPanel.remove();
            collapse.remove();
            link.remove();
            return _this.createcompletepost(textcontent, linkedcontent);
          }
        });
      };

      Plugin.prototype.createcompletepost = function(postcontent, linkedcontent) {
        var posttext;
        posttext = $("<p class = 'posttext'>" + postcontent + "</p>");
        if (linkedcontent !== null) $(this.element).append(linkedcontent);
        if (postcontent !== '') return $(this.element).append(posttext);
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
