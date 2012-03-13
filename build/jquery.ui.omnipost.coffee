 (($) ->
      $.widget "ui.omnipost",

        _create: ->
          collapse = $("<img alt='x' title='x' id='ui-omniPostCollapse'>")  
          collapse.attr('src', 'http://officeimg.vo.msecnd.net/en-us/images/MB900432537.jpg')
          text = $("<textarea id='ui-omniPostText'></textarea>")
          text.autoResize(extraSpace: 50).addClass('ui-omniPost')     
          @element.append(collapse)
          @element.append(text)
          @element.append($('<br/>'))
          post = $("<button id='ui-omniPostSubmit'>Post</button>")
          @element.append(post)
          @element.addClass('ui-omniPost')
          @element.focusin( =>
            unless text.attr('readonly')
              post.show()
              collapse.show()
              text.height(50) if text.height() < 50
            text.removeClass('ui-omniPostActive')
            if text.val() is @element.attr('title')
              text.val('')
          )
          collapse.click( =>          
            post.hide()
            text.val(@element.attr('title'))
            text.addClass('ui-omniPostActive')
            text.height(28)
            collapse.hide()
          ).click()
          @element.focusout( => collapse.click() if text.val() is '')

        destroy: ->
          @element.remove()

        _setOption: (option, value) ->
          $.Widget::_setOption.apply(this, arguments)

    ) jQuery
	
$('#myPostBox').omnipost()