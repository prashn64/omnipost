( ->
testUtils = 
  state: 0
  panelCount: 0

  states: 
    none: 0,
    open: 1
  defaultTestOptions:
    selector: '#myPostBox',
    voteboxOptions : {}
  
  init : (options) ->
    testUtils.reset()
    opts = $.extend {}, testUtils.defaultTestOptions, options
    $(opts.selector).omnipost(opts.voteboxOptions)
    $(opts.selector).bind('panelsChanged', testUtils.setPanelCount)
    $(opts.selector).bind('omnicontainerOpened', testUtils.setState)
    $(opts.selector).bind('linkpanelOpened', testUtils.setState)
    $(opts.selector).bind('videopanelOpened', testUtils.setState) 
    $(opts.selector).bind('omnicontainerClosed', testUtils.setState)     
    $(opts.selector)

  setState: (event, state) ->
    testUtils.state = state 

  setPanelCount: (event, count) ->
    testUtils.panelCount = count

  reset: ->
    $(testUtils.defaultTestOptions.selector).unbind('omnicontainerOpened', testUtils.setState)
    $(testUtils.defaultTestOptions.selector).unbind('linkpanelOpened', testUtils.setState)
    $(testUtils.defaultTestOptions.selector).unbind('videopanelOpened', testUtils.setState) 
    $(testUtils.defaultTestOptions.selector).unbind('omnicontainerClosed', testUtils.setState)  
    testUtils.voteDiff = 0

module("Module A") 
test("omnipost area clicked", 
  ( ->             
    omnipost = testUtils.init()
    omnipost.find('#ui-omniContainer').click()
    equal(testUtils.state, testUtils.states.open, "The omnicontainer has been clicked, state should be open")
  )
)

test("panel length testing", 
  ( ->             
    omnipost = testUtils.init()
    omnipost.find('#ui-omniPostAttach').click()
    equal(testUtils.panelCount, 1, "The link has been clicked, panel count should be 1")
    omnipost.find('#ui-omniPostVideoAttach').click()
    equal(testUtils.panelCount, 2, "The video has been clicked, panel count should be 2")   
    omnipost.find('.ui-videobox:eq(0) .ui-panelcollapseicon:eq(0)').click()
    equal(testUtils.panelCount, 1, "The video close icon has been clicked, panel count should be 1")
    omnipost.find('#ui-omniPostVideoAttach').click()
    equal(testUtils.panelCount, 2, "The video has been clicked again, panel count should be 2")
    omnipost.find('#ui-omniPostCollapse').click()
    equal(testUtils.panelCount, 0, "The omnipost window has been closed, panel count should be 0")
    equal(testUtils.state, testUtils.states.none, "The state should be none")
  )
)
)
