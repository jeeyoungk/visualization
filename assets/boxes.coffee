---
---
svg = d3.select("svg#canvas")
g = svg.append('g').attr('transform', 'translate(10, 10)')

class Grid
  # abstraction over the grid of boxes that can move around.
  constructor: (@row, @col) ->
    console.log @row, @col
    @grid = []  # link from grid location to boxes.
    @boxes = [] # all the boxes within the grid.
    for index in [1..@row]
      @grid.push (null for index in [1..@col])

  moveBox: (box, direction) =>
    # attempt to move the box to the given direction.
    # returns true if the moving is successful. false otherwise.
    {row, col} = box
    newrow = row + direction.row
    newcol = col + direction.col

    if not @inBound(newrow, newcol) then return false
    if @grid[newrow][newcol] isnt null then return false

    @grid[row][col] = null
    @grid[newrow][newcol] = box
    box.row = newrow; box.col = newcol
    return true

  newBox: (row, col) =>
    # add a new box to the given location.
    if not @inBound row, col then return null
    if @grid[row][col] isnt null then return null
    box = {row: row, col: col}
    @boxes.push box
    @grid[row][col] = box
    return box

  inBound: (row, col) => row >= 0 and col >= 0 and row < @row and col < @col

DIRECTIONS = {
  LEFT:  {row: -1, col:  0}
  RIGHT: {row:  1, col:  0}
  UP:    {row:  0, col: -1}
  DOWN:  {row:  0, col:  1}
}

CHOICES = [
  [DIRECTIONS.RIGHT, DIRECTIONS.DOWN]
  [DIRECTIONS.DOWN, DIRECTIONS.RIGHT]
]

window.oneByOne = ->
  runWithModification (context) ->
    {grid} = context
    moved = false
    if grid.boxes.length > 0
      last = grid.boxes[grid.boxes.length - 1]
      for choice in CHOICES[Math.floor(Math.random() * 2)]
        moved = grid.moveBox last, choice
        if moved
          break
    if not moved
      newBox = grid.newBox(0, 0)

window.streaming = ->
  unstacked = []
  runWithModification (context) ->
    {grid, counter} = context
    stillUnstacked = []
    for box in unstacked
      moved = false
      for choice in CHOICES[Math.floor(Math.random() * 2)]
        moved = grid.moveBox box, choice
        if moved
          break
      if moved
        stillUnstacked.push box
    unstacked = stillUnstacked
    if counter % 3 == 0
      newBox = grid.newBox(0, 0)
      if newBox isnt null
        unstacked.push newBox

previousInterval = null

runWithModification = (modification) ->
  # run a given modification function every interval to the grid,
  # and re-render / animate the grid as necessary.
  delay = 75
  CELL_SIZE = 20
  grid = new Grid(
    common.DIMENSION.HEIGHT / CELL_SIZE,
    common.DIMENSION.WIDTH / CELL_SIZE
  )
  yScale = (d) -> d.row * CELL_SIZE
  xScale = (d) -> d.col * CELL_SIZE
  rerender = ->
    g.selectAll('rect')
      .data(grid.boxes)
      .enter()
      .append('rect')
      .attr('width', CELL_SIZE)
      .attr('height', CELL_SIZE)
      .attr('stroke', 'black')
      .attr('stroke-width', 1)
      .attr('fill','none')
      .attr('x', xScale)
      .attr('y', yScale)

    g.selectAll('rect').data(grid.boxes).exit().remove()

  intervalCallback = (counter) ->
    # context passed to the modification function.
    context = {
      grid: grid
      counter: counter
    }
    modification(context)
    rerender()

    g.selectAll('rect')
      .transition()
      .attr('x', xScale)
      .attr('y', yScale)
      .duration(delay * 0.8)

  if previousInterval isnt null
    window.clearInterval previousInterval
  rerender()
  previousInterval = common.withCounter intervalCallback, delay
window.oneByOne()
