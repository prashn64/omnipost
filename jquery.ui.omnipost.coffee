(($, window, document) ->

  pluginName = 'omnipost'
  defaults =
    editing: true
    postcontent: ''
    linkedcontent: ''

  class Panel
    constructor: (@id, @iconSrc, @collapseSrc) ->
      @init()
        
    init: =>
      @panelcontainer = $("<div class=#{@id}></div>")
      @linkbox = $("<textarea class='ui-omniPostLink'></textarea>")
      @linkIcon = $("<img class = 'ui-panelicon' src = #{@iconSrc} alt = 'attach'>")       
      @collapseIcon = $("<img class = 'ui-panelcollapseicon' src = #{@collapseSrc} alt = 'collapse'>")
      @submitLink = $("<button class='ui-submitLink'>Add</button>")
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
      @panelcontainer.show()
                      
    hide: =>
      @linkbox.val('')
      @linktosite.text('')
      @panelcontainer.hide()

    isEmpty: =>
      return @linkbox.val() is ''
  
    remove: =>
       @panelcontainer.remove()

  class LinkPanel extends Panel   
    init: ->
      @maxwidth = 300;
      super.init()
      @displayedContent = 'none'
      @attachedImage = $("<img width = '#{@maxwidth}' height = 'auto' class = 'ui-attachedImage' src = '' alt = 'attach'>")
      @linktosite = $("<a href = #{@linkbox.val()} class = 'ui-linkToSite'></a>")
      @panelcontainer.append(@attachedImage)
      @panelcontainer.append(@linktosite)
      @attachedImage.hide()
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
        )
      )
    
    hide: =>
      super.hide()
      @attachedImage.attr('src', '')

    content: =>
      if @displayedContent is 'image'
        return @attachedImage
      else if @displayedContent is 'link'
        return @linktosite
      else
        return null
 
  class Plugin
    constructor: (@element, options) ->
      @options = $.extend {}, defaults, options
      @_defaults = defaults
      @_name = 'tagbox'
      @init()
    
    init: ->
      if @options.editing
        linkPanel = new LinkPanel('ui-linkbox', 'http://b.dryicons.com/images/icon_sets/coquette_part_2_icons_set/png/128x128/attachment.png', 'http://officeimg.vo.msecnd.net/en-us/images/MB900432537.jpg')
        collapse = $("<img alt='x' title='x' id='ui-omniPostCollapse'>")  
        collapse.attr('src', 'http://officeimg.vo.msecnd.net/en-us/images/MB900432537.jpg')
        link = $("<img alt='a' title='attach a link' id='ui-omniPostAttach'>")
        link.attr('src', 'http://b.dryicons.com/images/icon_sets/coquette_part_2_icons_set/png/128x128/attachment.png')
        omnicontainer = $("<div id='ui-omniContainer'></div>")
        text = $("<textarea id='ui-omniPostText'></textarea>")
        text.autoResize(extraSpace: 50).addClass('ui-omniPost')
        selectedImageLink = $("<img alt='x' title='your linked image' id='ui-omniPostImage'>")  
        selectedImageLink.hide()        
        omnicontainer.append(text)
        omnicontainer.append(collapse)
        omnicontainer.append(link)
        $(@element).append(omnicontainer)
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
        
        collapse.click( =>          
          post.hide()
          text.val($(@element).attr('title'))
          text.addClass('ui-omniPostActive')
          text.height(28)
          collapse.hide()
          link.hide()
          linkPanel.hide()
        ).click()
        # $(@element).focusout( => collapse.click() if text.val() is '')
        
        link.click( =>
          linkPanel.show()
        )
        
        post.click( =>
          if text.val() != '' or !linkPanel.isEmpty() 
            post.remove()
            textcontent = text.val()
            text.remove()
            linkedcontent = linkPanel.content()
            linkPanel.remove()
            collapse.remove()
            link.remove()
            @createcompletepost(textcontent, linkedcontent)
        )          
      else
        @createcompletepost(@options.postcontent, @options.linkedcontent)

    createcompletepost: (postcontent, linkedcontent) =>
      posttext = $("<p class = 'posttext'>#{postcontent}</p>")
      linkedelement = $("<img src = #{linkedcontent} alt = 'linked content' />")
      $(document).ready( =>
        linkedelement.error( =>  
          linkedelement.remove()
          linkedelement = $("<a href = #{linkedcontent}>#{linkedcontent}</a>")            
          unless linkedcontent.indexOf("http://") is 0 
            linkedelement.attr('href', 'http://' + linkedelement.attr('href'))
          linkedcontentpreview = $("<iframe id='frame' src=#{linkedelement.attr('href')} scrolling = no></iframe>")
          @omnifinaldiv.prepend(linkedelement)
          @omnifinaldiv.prepend(linkedcontentpreview)
        )
      )
      @omnifinaldiv = $("<div id = 'ui-postedcontent'></div>")
      unless linkedcontent is null
        @omnifinaldiv.append(linkedelement)
      unless postcontent is ''         
        @omnifinaldiv.append(posttext)
      $(@element).append(@omnifinaldiv)
      

    destroy: ->
      $(@element).remove()
    
    _setOption: (option, value) ->
      $.Widget::_setOption.apply(this, arguments)
    
    $.fn[pluginName] = (options) ->
        @each ->
          if !$.data(this, "plugin_#{pluginName}")
            $.data(@, "plugin_#{pluginName}", new Plugin(@, options))
)(jQuery, window, document)
