(($, window, document) ->

  pluginName = 'omnipost'
  defaults =
    property: 'value'

  class Panel
    constructor: (@id, @iconSrc, @collapseSrc) ->
      @init()
        
    init: =>
      @panelcontainer = $("<div id=#{@id}></div>")
      @linkBox = $("<textarea id='ui-omniPostLink'></textarea>")
      @linkBox.height(25)
      @linkBox.width(500)
      @linkIcon = $("<img src = #{@iconSrc} alt = 'attach'>")
      @panelcontainer.append(@linkBox)
      
    addPanelToContainer: (container) =>
      container.append(@panelcontainer)
             
    show: =>
      @panelcontainer.show()
                      
    hide: =>
      @panelcontainer.hide()

  class LinkPanel extends Panel   
    init: ->
      super.init()
      attachedImage = $("<img src = '' alt = 'attach'>")
      @panelcontainer.append(attachedImage) 
      
      @linkBox.change( =>
        attachedImage.attr('src', @linkBox.val())
      )

  class Plugin
    constructor: (@element, options) ->
      @options = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = 'tagbox'
      @init()
    
    init: ->
      linkPanel = new LinkPanel('ui-linkBox', 'http://b.dryicons.com/images/icon_sets/coquette_part_2_icons_set/png/128x128/attachment.png', 'http://officeimg.vo.msecnd.net/en-us/images/MB900432537.jpg')
      collapse = $("<img alt='x' title='x' id='ui-omniPostCollapse'>")  
      collapse.attr('src', 'http://officeimg.vo.msecnd.net/en-us/images/MB900432537.jpg')
      link = $("<img alt='a' title='attach a link' id='ui-omniPostAttach'>")
      link.attr('src', 'http://b.dryicons.com/images/icon_sets/coquette_part_2_icons_set/png/128x128/attachment.png')
      text = $("<textarea id='ui-omniPostText'></textarea>")
      text.autoResize(extraSpace: 50).addClass('ui-omniPost')     
      # linkBox = $("<textarea id='ui-omniPostLink'></textarea>")
      # linkBox.height(25)
      # linkBox.width(500)
      selectedImageLink = $("<img alt='x' title='your linked image' id='ui-omniPostImage'>")  
      selectedImageLink.hide()
      $(@element).append(collapse)
      $(@element).append(link)
      $(@element).append(text)
      linkPanel.addPanelToContainer($(@element))
      linkPanel.hide()
      $(@element).append(selectedImageLink)
      $(@element).append($('<br/>'))
      post = $("<button id='ui-omniPostSubmit'>Post</button>")
      $(@element).append(post)
      $(@element).addClass('ui-omniPost')
      $(@element).focusin( =>
        unless text.attr('readonly')
          post.show()
          collapse.show()
          link.show()
          text.height(50) if text.height() < 50
        text.removeClass('ui-omniPostActive')
        if text.val() is $(@element).attr('title')
          text.val('')
      )
	  
      # linkBox.change( =>   
      #  selectedImageLink.show() 
      #  selectedImageLink.attr('src', linkBox.val())           
      # )
	  
      collapse.click( =>          
        # post.hide()
        # text.val($(@element).attr('title'))
        # text.addClass('ui-omniPostActive')
        # text.height(28)
        # collapse.hide()
        # link.hide()
        # linkBox.val('')
        # linkPanel.hide()
        # selectedImageLink.hide()
      ).click()
      $(@element).focusout( => collapse.click() if text.val() is '')
      
      link.click( =>
        linkPanel.show()
      )
                
    destroy: ->
      $(@element).remove()
    
    _setOption: (option, value) ->
      $.Widget::_setOption.apply(this, arguments)
    
    $.fn[pluginName] = (options) ->
        @each ->
          if !$.data(this, "plugin_#{pluginName}")
            $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
)(jQuery, window, document)
