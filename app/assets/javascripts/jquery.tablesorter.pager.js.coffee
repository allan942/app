(($) ->
  $.extend tablesorterPager: new (->

    updatePageDisplay = (c) ->
      s = $(c.cssPageDisplay, c.container).val(c.page + 1 + c.seperator + c.totalPages)
      return

    setPageSize = (table, size) ->
      c = table.config
      c.size = size
      c.totalPages = Math.ceil(c.totalRows / c.size)
      c.pagerPositionSet = false
      moveToPage table
      fixPosition table
      return

    fixPosition = (table) ->
      `var c`
      c = table.config
      if !c.pagerPositionSet and c.positionFixed
        c = table.config
        o = $(table)
        if o.offset
          c.container.css
            top: o.offset().top + o.height() + 'px'
            position: 'absolute'
        c.pagerPositionSet = true
      return

    moveToFirstPage = (table) ->
      c = table.config
      c.page = 0
      moveToPage table
      return

    moveToLastPage = (table) ->
      c = table.config
      c.page = c.totalPages - 1
      moveToPage table
      return

    moveToNextPage = (table) ->
      c = table.config
      c.page++
      if c.page >= c.totalPages - 1
        c.page = c.totalPages - 1
      moveToPage table
      return

    moveToPrevPage = (table) ->
      c = table.config
      c.page--
      if c.page <= 0
        c.page = 0
      moveToPage table
      return

    moveToPage = (table) ->
      c = table.config
      if c.page < 0 or c.page > c.totalPages - 1
        c.page = 0
      renderTable table, c.rowsCopy
      return

    renderTable = (table, rows) ->
      `var l`
      c = table.config
      l = rows.length
      s = c.page * c.size
      e = s + c.size
      if e > rows.length
        e = rows.length
      tableBody = $(table.tBodies[0])
      # clear the table body
      $.tablesorter.clearTableBody table
      i = s
      while i < e
        #tableBody.append(rows[i]);
        o = rows[i]
        l = o.length
        j = 0
        while j < l
          tableBody[0].appendChild o[j]
          j++
        i++
      fixPosition table, tableBody
      $(table).trigger 'applyWidgets'
      if c.page >= c.totalPages
        moveToLastPage table
      updatePageDisplay c
      return

    @appender = (table, rows) ->
      c = table.config
      c.rowsCopy = rows
      c.totalRows = rows.length
      c.totalPages = Math.ceil(c.totalRows / c.size)
      renderTable table, rows
      return

    @defaults =
      size: 10
      offset: 0
      page: 0
      totalRows: 0
      totalPages: 0
      container: null
      cssNext: '.next'
      cssPrev: '.prev'
      cssFirst: '.first'
      cssLast: '.last'
      cssPageDisplay: '.pagedisplay'
      cssPageSize: '.pagesize'
      seperator: '/'
      positionFixed: true
      appender: @appender

    @construct = (settings) ->
      @each ->
        config = $.extend(@config, $.tablesorterPager.defaults, settings)
        table = this
        pager = config.container
        $(this).trigger 'appendCache'
        config.size = parseInt($('.pagesize', pager).val())
        $(config.cssFirst, pager).click ->
          moveToFirstPage table
          false
        $(config.cssNext, pager).click ->
          moveToNextPage table
          false
        $(config.cssPrev, pager).click ->
          moveToPrevPage table
          false
        $(config.cssLast, pager).click ->
          moveToLastPage table
          false
        $(config.cssPageSize, pager).change ->
          setPageSize table, parseInt($(this).val())
          false
        return

    return
)
  # extend plugin scope
  $.fn.extend tablesorterPager: $.tablesorterPager.construct
  return
) jQuery

# ---
# generated by js2coffee 2.2.0