---
---
# Implementation of a stack, with the associated visualization
data = [1,2,3,4,null,null]
dimension = 50
svg = d3.select("svg#canvas")

g = svg.append('g').attr('transform', "translate(100, 100)")

g.append('line')
  .attr('x1', 0)
  .attr('x2', 0)
  .attr('y1', 0)
  .attr('y1', dimension + dimension * 0.5)
  .attr('stroke', 'black')
  .attr('stroke-width', 4)

g.selectAll('rect')
  .data(data)
  .enter().append('rect')
  .attr('x', (d, i) -> i * dimension)
  .attr('y', 0)
  .attr('width', dimension)
  .attr('height', dimension)
  .attr('fill', 'none')
  .attr('stroke', 'black')
  .attr('stroke-width', 1)

