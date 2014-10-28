TreeView = ionic.views.View.inherit(
  initialize: (opts) ->
    return

    _this = this
    opts = ionic.extend(
      onReorder: (el, oldIndex, newIndex) ->

      virtualRemoveThreshold: -200
      virtualAddThreshold: 200
      canSwipe: ->
        true
    , opts)
    ionic.extend this, opts
    @itemHeight = @listEl.children[0] and parseInt(@listEl.children[0].style.height, 10)  if not @itemHeight and @listEl
    
    #ionic.views.ListView.__super__.initialize.call(this, opts);
    @onRefresh = opts.onRefresh or ->

    @onRefreshOpening = opts.onRefreshOpening or ->

    @onRefreshHolding = opts.onRefreshHolding or ->

    window.ionic.onGesture "release", ((e) ->
      _this._handleEndDrag e
      return
    ), @el
    window.ionic.onGesture "drag", ((e) ->
      _this._handleDrag e
      return
    ), @el
    
    # Start the drag states
    @_initDrag()
    return

  
  ###*
  Called to tell the list to stop refreshing. This is useful
  if you are refreshing the list and are done with refreshing.
  ###
  stopRefreshing: ->
    refresher = @el.querySelector(".list-refresher")
    refresher.style.height = "0px"
    return

  
  ###*
  If we scrolled and have virtual mode enabled, compute the window
  of active elements in order to figure out the viewport to render.
  ###
  didScroll: (e) ->
    if @isVirtual
      itemHeight = @itemHeight
      
      # TODO: This would be inaccurate if we are windowed
      totalItems = @listEl.children.length
      
      # Grab the total height of the list
      scrollHeight = e.target.scrollHeight
      
      # Get the viewport height
      viewportHeight = @el.parentNode.offsetHeight
      
      # scrollTop is the current scroll position
      scrollTop = e.scrollTop
      
      # High water is the pixel position of the first element to include (everything before
      # that will be removed)
      highWater = Math.max(0, e.scrollTop + @virtualRemoveThreshold)
      
      # Low water is the pixel position of the last element to include (everything after
      # that will be removed)
      lowWater = Math.min(scrollHeight, Math.abs(e.scrollTop) + viewportHeight + @virtualAddThreshold)
      
      # Compute how many items per viewport size can show
      itemsPerViewport = Math.floor((lowWater - highWater) / itemHeight)
      
      # Get the first and last elements in the list based on how many can fit
      # between the pixel range of lowWater and highWater
      first = parseInt(Math.abs(highWater / itemHeight), 10)
      last = parseInt(Math.abs(lowWater / itemHeight), 10)
      
      # Get the items we need to remove
      @_virtualItemsToRemove = Array::slice.call(@listEl.children, 0, first)
      
      # Grab the nodes we will be showing
      nodes = Array::slice.call(@listEl.children, first, first + itemsPerViewport)
      @renderViewport and @renderViewport(highWater, lowWater, first, last)
    return

  didStopScrolling: (e) ->
    if @isVirtual
      i = 0

      while i < @_virtualItemsToRemove.length
        el = @_virtualItemsToRemove[i]
        
        #el.parentNode.removeChild(el);
        @didHideItem and @didHideItem(i)
        i++
    return

  
  # Once scrolling stops, check if we need to remove old items
  
  ###*
  Clear any active drag effects on the list.
  ###
  clearDragEffects: ->
    if @_lastDragOp
      @_lastDragOp.clean and @_lastDragOp.clean()
      @_lastDragOp = null
    return

  _initDrag: ->
    
    #ionic.views.ListView.__super__._initDrag.call(this);
    
    # Store the last one
    @_lastDragOp = @_dragOp
    @_dragOp = null
    return

  
  # Return the list item from the given target
  _getItem: (target) ->
    while target
      return target  if target.classList and target.classList.contains(ITEM_CLASS)
      target = target.parentNode
    null

  _startDrag: (e) ->
    _this = this
    didStart = false
    @_isDragging = false
    lastDragOp = @_lastDragOp
    item = undefined
    
    # Check if this is a reorder drag
    if ionic.DomUtil.getParentOrSelfWithClass(e.target, ITEM_REORDER_BTN_CLASS) and (e.gesture.direction is "up" or e.gesture.direction is "down")
      item = @_getItem(e.target)
      if item
        @_dragOp = new ReorderDrag(
          listEl: @el
          el: item
          scrollEl: @scrollEl
          scrollView: @scrollView
          onReorder: (el, start, end) ->
            _this.onReorder and _this.onReorder(el, start, end)
            return
        )
        @_dragOp.start e
        e.preventDefault()
    
    # Or check if this is a swipe to the side drag
    else if not @_didDragUpOrDown and (e.gesture.direction is "left" or e.gesture.direction is "right") and Math.abs(e.gesture.deltaX) > 5
      
      # Make sure this is an item with buttons
      item = @_getItem(e.target)
      if item and item.querySelector(".item-options")
        @_dragOp = new SlideDrag(
          el: @el
          canSwipe: @canSwipe
        )
        @_dragOp.start e
        e.preventDefault()
    
    # If we had a last drag operation and this is a new one on a different item, clean that last one
    lastDragOp.clean and lastDragOp.clean()  if lastDragOp and @_dragOp and not @_dragOp.isSameItem(lastDragOp) and e.defaultPrevented
    return

  _handleEndDrag: (e) ->
    _this = this
    @_didDragUpOrDown = false
    
    #ionic.views.ListView.__super__._handleEndDrag.call(this, e);
    return  unless @_dragOp
    @_dragOp.end e, ->
      _this._initDrag()
      return

    return

  
  ###*
  Process the drag event to move the item to the left or right.
  ###
  _handleDrag: (e) ->
    _this = this
    content = undefined
    buttons = undefined
    @_didDragUpOrDown = true  if Math.abs(e.gesture.deltaY) > 5
    
    # If we get a drag event, make sure we aren't in another drag, then check if we should
    # start one
    @_startDrag e  if not @isDragging and not @_dragOp
    
    # No drag still, pass it up
    
    #ionic.views.ListView.__super__._handleDrag.call(this, e);
    return  unless @_dragOp
    e.gesture.srcEvent.preventDefault()
    @_dragOp.drag e
    return
)