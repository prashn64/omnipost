(function() {
  var testUtils;

  (function() {});
  testUtils = {
    state: 'none',
    defaultTestOptions: {
      selector: '#myPostBox',
      voteboxOptions: {}
    },
    init: function(options) {
      var opts;
      testUtils.reset();
      opts = $.extend({}, testUtils.defaultTestOptions, options);
      $(opts.selector).omnipost(opts.voteboxOptions);
      $(opts.selector).bind('omnicontainerOpened', testUtils.setState);
      $(opts.selector).bind('linkpanelOpened', testUtils.setState);
      $(opts.selector).bind('videopanelOpened', testUtils.setState);
      $(opts.selector).bind('omnicontainerClosed', testUtils.setState);
      return $(opts.selector);
    },
    setState: function(event, state) {
      return testUtils.state = state;
    },
    reset: function() {
      $('#votebox').unbind('upArrowPressed');
      return testUtils.voteDiff = 0;
    }
  };
  module("Module A");
  test("omnipost area clicked", (function() {
    var omnipost;
    omnipost = testUtils.init();
    omnipost.find('#ui-omniContainer').click();
    return equal(testUtils.state, 'text', "The omnicontainer has been clicked, state should be text");
  }));
  test("link button clicked", (function() {
    var omnipost;
    omnipost = testUtils.init();
    omnipost.find('#ui-omniPostAttach').click();
    return equal(testUtils.state, 'link', "The link has been clicked, state should be link");
  }));
  test("video button clicked after link button", (function() {
    var omnipost;
    omnipost = testUtils.init();
    omnipost.find('#ui-omniPostVideoAttach').click();
    return equal(testUtils.state, 'linkandvideo', "The video has been clicked, state should be linkandvideo");
  }));
  test("collapse button clicked", (function() {
    var omnipost;
    omnipost = testUtils.init();
    omnipost.find('#ui-omniPostCollapse').click();
    return equal(testUtils.state, 'none', "The video has been clicked, state should be none");
  }));
  test("link button clicked after video button", (function() {
    var omnipost;
    omnipost = testUtils.init();
    omnipost.find('#ui-omniContainer').click();
    omnipost.find('#ui-omniPostVideoAttach').click();
    omnipost.find('#ui-omniPostAttach').click();
    return equal(testUtils.state, 'videoandlink', "The link has been clicked, state should be videoandlink");
  }));

}).call(this);
