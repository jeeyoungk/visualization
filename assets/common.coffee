---
---
# Common coffeescript files to be shared between
# all the visualization examples.
DIMENSION = {
  WIDTH: 400
  HEIGHT: 300
}

withCounter = (callback, interval=1000/60) ->
  counter = 0
  wrapped = ->
    callback(counter)
    counter++

  setInterval wrapped, interval


randRange = (start, end) ->
  Math.random() * (end - start) + start

window.common = {DIMENSION, withCounter, randRange}
