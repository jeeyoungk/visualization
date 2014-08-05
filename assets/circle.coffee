---
---
# Implementation of a stack, with the associated visualization
svg = d3.select("svg#canvas")

MARGIN = 20
RADIUS = 10

g = svg.append('g')

max = 120

periodFunction = (value, period) ->
  value = value % period
  if value > period / 2
    value = period - value
  return value

scales = []
for i in [1..10]
  start = common.randRange(MARGIN, common.DIMENSION.WIDTH - MARGIN)
  end =   common.randRange(MARGIN, common.DIMENSION.WIDTH - MARGIN)
  period = Math.floor(Math.random() * 100 + 100)
  scales.push(
    {
      scale: d3.scale.linear().domain([0, period / 2]).range([start, end])
      period: period
    }
  )
selected = g.selectAll('circle')
  .data(scales)
  .enter().append('circle')
  .attr('cx', 0)
  .attr('cy', (d, i) -> MARGIN + i * RADIUS * 2.5)
  .attr('fill','none')
  .attr('stroke', 'black')
  .attr('stroke-width', '1')
  .attr('r', RADIUS)

callback = (counter) ->
  selected
    .attr('cx', (data) ->
      {scale, period} = data
      value = periodFunction counter, period
      scale value)


common.withCounter callback
