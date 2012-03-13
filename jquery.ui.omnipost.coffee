(($) ->
  $.widget "ui.omnipost",
    _create: ->
      collapse = $("<img alt='x' title='x' id='ui-omniPostCollapse'>")  
      collapse.attr('src', 'http://officeimg.vo.msecnd.net/en-us/images/MB900432537.jpg')
      link = $("<img alt='a' title='attach a link' id='ui-omniPostAttach'>")
      link.attr('src', 'http://b.dryicons.com/images/icon_sets/coquette_part_2_icons_set/png/128x128/attachment.png')
      text = $("<textarea id='ui-omniPostText'></textarea>")
      text.autoResize(extraSpace: 50).addClass('ui-omniPost')     
      linkBox = $("<textarea id='ui-omniPostLink'></textarea>")
      linkBox.height(25)
      linkBox.width(500)
      selectedImageLink = $("<img alt='x' title='your linked image' id='ui-omniPostImage'>")  
      selectedImageLink.hide()
      @element.append(collapse)
      @element.append(link)
      @element.append(text)
      @element.append(linkBox)
      @element.append(selectedImageLink)
      @element.append($('<br/>'))
      post = $("<button id='ui-omniPostSubmit'>Post</button>")
      @element.append(post)
      @element.addClass('ui-omniPost')
      @element.focusin( =>
        unless text.attr('readonly')
          post.show()
          collapse.show()
          link.show()
          text.height(50) if text.height() < 50
        text.removeClass('ui-omniPostActive')
        if text.val() is @element.attr('title')
          text.val('')
      )
	  
      linkBox.change( =>   
        selectedImageLink.show() 
        selectedImageLink.attr('src', linkBox.val())           
      )
	  
      collapse.click( =>          
        post.hide()
        text.val(@element.attr('title'))
        text.addClass('ui-omniPostActive')
        text.height(28)
        collapse.hide()
        link.hide()
        linkBox.val('')
        linkBox.hide()
        selectedImageLink.hide()
      ).click()
      @element.focusout( => collapse.click() if text.val() is '' and not linkBox.visible())
      
      link.click( =>
        linkBox.show()
      )
                
    destroy: ->
      @element.remove()

    _setOption: (option, value) ->
      $.Widget::_setOption.apply(this, arguments)

) jQuery
      
$("#myPostBox").omnipost()