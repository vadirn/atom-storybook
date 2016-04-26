window.$ = window.jQuery = require('../node_modules/jquery')
AtomStorybookView = require './atom-storybook-view'


{CompositeDisposable} = require 'atom'

module.exports = AtomStorybook =
  AtomStorybookView: null
  modalPanel: null
  subscriptions: null
  enlarged : false
  isWindowResizingAllowed : false

  config:
    atomStorybookUrl:
      type: 'string'
      default: 'http://localhost:9001'

  activate: (state) ->
    @AtomStorybookView = new AtomStorybookView(state.AtomStorybookViewState)
    @modalPanel = atom.workspace.addRightPanel(item: @AtomStorybookView.getElement(), visible: false)

    # Events subscribed to in atom's system can be easily cleaned up with a CompositeDisposable
    @subscriptions = new CompositeDisposable

    # Register command that toggles this view
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-storybook:toggle': => @toggle()
    @subscriptions.add atom.commands.add 'atom-workspace', 'atom-storybook:enlarge': => @enlarge()

    $(document).ready ->
      height = $(window).height()
      width = $(window).width()
      $('.atom-storybook').width(width / 2.5)
      $('.atom-storybook').append('<webview id="atom-storybook" src="' + atom.config.get('atom-storybook.atomStorybookUrl') + '"></webview>')
      $(window).on 'resize' , ->
        if @isWindowResizingAllowed
          width = $(window).width()
          if @enlarged
            $('.atom-storybook').width(width / 2)
          else
            $('.atom-storybook').width(width / 2.5)



  deactivate: ->
    @modalPanel.destroy()
    @subscriptions.dispose()
    @AtomStorybookView.destroy()

  serialize: ->
    AtomStorybookViewState: @AtomStorybookView.serialize()

  toggle: ->
    if @modalPanel.isVisible()
      @modalPanel.hide()
    else
      @modalPanel.show()

  enlarge: ->
    @isWindowResizingAllowed = false
    if @enlarged == false
      $('.atom-storybook').width($(window).width() / 2)
      @enlarged = true
    else
      $('.atom-storybook').width($(window).width() / 2.5)
      @enlarged = false
    @isWindowResizingAllowed = true
