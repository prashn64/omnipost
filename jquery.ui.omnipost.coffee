(($, window, document) ->

  pluginName = 'omnipost'
  defaults =
    editing: true
    callback: ''
    postcontent: ''
    linkedcontent: ''

  class Panel
    constructor: (@id, @iconSrc, @collapseSrc) ->
      @init()
        
    init: =>
      @slideSpeed = 200
      @panelcontainer = $("<div class=#{@id}></div>")
      @linkIcon = $("<img class = 'ui-panelicon' src = #{@iconSrc} alt = 'attach'>")       
      @collapseIcon = $("<img class = 'ui-panelcollapseicon' src = #{@collapseSrc} alt = 'collapse'>")
      @panelcontainer.append(@linkIcon)
      @panelcontainer.append(@linkbox)     
      @panelcontainer.append(@collapseIcon)
      @panelcontainer.append(@submitLink) 
      @collapseIcon.click( =>
        @hide()
      )

    addPanelToContainer: (container) =>
      container.append(@panelcontainer)
             
    show: =>
      @panelcontainer.show("slide", { direction: "up" }, @slideSpeed)
                      
    hide: =>
      @panelcontainer.hide()

    isEmpty: =>
      return @linkbox.val() is ''
  
    remove: =>
       @panelcontainer.remove()

  class LinkPanel extends Panel   
    init: ->
      @maximagewidth = 350;
      super.init()
      @linkbox = $("<textarea class='ui-omniPostLink'></textarea>")
      @submitLink = $("<button class='ui-submitLink'>Add</button>")
      @displayedContent = 'none'
      @attachedImage = $("<img width = '#{@maximagewidth}' height = 'auto' class = 'ui-attachedImage' src = '' alt = 'attach'>")
      @linktosite = $("<a href = #{@linkbox.val()} class = 'ui-linkToSite'></a>")
      @linkedcontentpreview = $("<iframe id='frame' src='' scrolling = no></iframe>")
      @panelcontainer.append(@linkbox)
      @panelcontainer.append(@submitLink)      
      @panelcontainer.append(@attachedImage)
      @panelcontainer.append(@linktosite)
      @panelcontainer.append(@linkedcontentpreview)
      @attachedImage.hide()
      @linkedcontentpreview.hide()
      @linkbox.change( =>
        @displayedContent = 'image'
        @attachedImage.show()
        @linktosite.text('')
        @attachedImage.attr('src', @linkbox.val())
      )
      
      $(document).ready( =>
        @attachedImage.error( =>  
          @attachedImage.hide()
          unless @attachedImage.attr('src') is ''
            @displayedContent = 'link'
            @linktosite.attr('href', @linkbox.val())
            @linktosite.text(@linkbox.val())            
            unless @linktosite.text().indexOf("http://") is 0 
              @linktosite.attr('href', 'http://' + @linktosite.attr('href'))
            @linkedcontentpreview.show()
            @linkedcontentpreview.attr('src', @linktosite.attr('href'))
        )
      )
    
    hide: =>
      super.hide()      
      @linkbox.val('')
      @attachedImage.attr('src', '')
      @linktosite.text('')
      @linkedcontentpreview.attr('src', '')
      @linkedcontentpreview.hide()

    content: =>
      if @displayedContent is 'image'
        return $.trim(@attachedImage[0].outerHTML)
      else if @displayedContent is 'link'
        return $.trim(@linktosite[0].outerHTML)
      else
        return null
 
  class VideoPanel extends Panel
    init: ->
      super.init()
      @linkbox = $("<textarea class='ui-omniPostLink'></textarea>")
      @submitLink = $("<button class='ui-submitLink'>Add</button>")
      @panelcontainer.append(@linkbox)
      @panelcontainer.append(@submitLink)

  class Plugin
    constructor: (@element, options) ->
      @options = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = 'tagbox'
      @init()
    
    init: ->
      message = 'Post your reply here...'
      omnipostdiv = $("<div class = 'ui-omnipost'></div>")
      linkPanel = new LinkPanel('ui-linkbox', '/images/linkAttach.png', '/images/collapse.png')
      videoPanel = new VideoPanel('ui-videobox', '/images/videoAttach.png', '/images/collapse.png')
      collapse = $("<img alt='x' title='x' id='ui-omniPostCollapse'>")  
      collapse.attr('src', '/images/collapse.png')
      link = $("<img alt='a' title='attach a link' id='ui-omniPostAttach'>")
      link.attr('src', '/images/linkAttach.png')
      videolink = $("<img alt='a' title='attach a link' id='ui-omniPostVideoAttach'>")
      videolink.attr('src', '/images/videoAttach.png')
      panelselectors = $("<div id = 'ui-panelSelectors'></div>")        
      panelselectors.append(videolink)
      panelselectors.append(link)
      omnicontainer = $("<div id='ui-omniContainer'></div>")
      text = $("<textarea id='ui-omniPostText'></textarea>")
      text.autoResize(extraSpace: 50).addClass('ui-omniPost')
      selectedImageLink = $("<img alt='x' title='your linked image' id='ui-omniPostImage'>")  
      selectedImageLink.hide()        
      omnicontainer.append(text)
      omnicontainer.append(collapse)
      omnicontainer.append(panelselectors)
      omnipostdiv.append(omnicontainer)
      linkPanel.addPanelToContainer(omnipostdiv)
      linkPanel.hide()
      videoPanel.addPanelToContainer(omnipostdiv)
      videoPanel.hide()
      $(@element).append(selectedImageLink)
      $(@element).append($('<br/>'))
      post = $("<button id='ui-omniPostSubmit'>Post</button>")
      omnipostdiv.append(post)
      $(@element).append(omnipostdiv)
      $(@element).addClass('ui-omniPost')
      omnicontainer.focusin( =>
        unless text.attr('readonly')
          post.show()
          collapse.show()
          panelselectors.show()
          text.height(50) if text.height() < 50
        text.removeClass('ui-omniPostActive')
        if text.val() is message
          text.val('')
      )
     
      collapse.click( =>          
        post.hide()
        text.val(message)
        text.addClass('ui-omniPostActive')
        text.height(28)
        collapse.hide()
        panelselectors.hide()
        linkPanel.hide()
        videoPanel.hide()
      ).click()
      # $(@element).focusout( => collapse.click() if text.val() is '')
        
      link.click( =>
        event.stopPrapogation()
        linkPanel.show()
      )
        
      videolink.click( =>
        event.stopPropagation()
        videoPanel.show()
      )
        
      content: =>
        data = {posttext: $.trim(text.val()), linkdata: linkPanel.content()}
        return data
  
      post.click( =>
        data = {posttext: $.trim(text.val()), linkdata: linkPanel.content()}        
        omnipostdiv.remove()
        @options.callback(data)
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
