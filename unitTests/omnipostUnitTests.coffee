( ->
testUtils = 
  state: 'none'

  defaultTestOptions:
    selector: '#myPostBox',
    voteboxOptions : {}
  
  init : (options) ->
    testUtils.reset()
    opts = $.extend {}, testUtils.defaultTestOptions, options
    $(opts.selector).omnipost(opts.voteboxOptions)
    $(opts.selector).bind('omnicontainerOpened', testUtils.setState)
    $(opts.selector).bind('linkpanelOpened', testUtils.setState)
    $(opts.selector).bind('videopanelOpened', testUtils.setState) 
    $(opts.selector).bind('omnicontainerClosed', testUtils.setState)     
    $(opts.selector)

  setState: (event, state) ->
    testUtils.state = state 

  reset: ->
    $('#votebox').unbind('upArrowPressed')
    testUtils.voteDiff = 0

module("Module A") 
test("omnipost area clicked", 
  ( ->             
    omnipost = testUtils.init()
    omnipost.find('#ui-omniContainer').click()
    equal(testUtils.state, 'text', "The omnicontainer has been clicked, state should be text")
  )
)

test("link button clicked", 
  ( ->             
    omnipost = testUtils.init()
    omnipost.find('#ui-omniPostAttach').click()
    equal(testUtils.state, 'link', "The link has been clicked, state should be link")
  )
)

test("video button clicked after link button", 
  ( ->             
    omnipost = testUtils.init()
    omnipost.find('#ui-omniPostVideoAttach').click()
    equal(testUtils.state, 'linkandvideo', "The video has been clicked, state should be linkandvideo")
  )
)

test("collapse button clicked", 
  ( ->             
    omnipost = testUtils.init()
    omnipost.find('#ui-omniPostCollapse').click()
    equal(testUtils.state, 'none', "The video has been clicked, state should be none")
  )
)
)
