{View} = require '../node_modules/atom-space-pen-views'

module.exports =
class AtomStorybookView extends View
  @content: ->
    @div class: 'storybook-view tool-panel', =>
      @div class: 'storybook-view-resize-handle', outlet: 'resizeHandle'

  initialize: (state) ->
    @handleEvents()
    @width(state.width) if state.width > 0

  handleEvents: ->
    @on 'mousedown', '.storybook-view-resize-handle', (e) => @resizeStarted(e)

  # Returns an object that can be retrieved when package is activated
  serialize: ->
    width: @width()

  # Tear down any state and detach
  destroy: ->
    @element.remove()

  getElement: ->
    @element

  resizeStarted: =>
    $(document).on('mousemove', @resizeView)
    $(document).on('mouseup', @resizeStopped)

  resizeStopped: =>
    $(document).off('mousemove', @resizeView)
    $(document).off('mouseup', @resizeStopped)

  resizeView: ({pageX, which}) =>
    return @resizeStopped() unless which is 1
    width = @outerWidth() + @offset().left - pageX
    maxWidth = atom.getSize().width / 1.5
    if width >= maxWidth
      width = maxWidth
    @width(width)
