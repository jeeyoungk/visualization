---
layout: post
title:  "Visualizing Stack"
date:   2014-07-31 00:44:00
---

Interface
---------

{% highlight coffeescript %}
class Stack
  push: (elem) -> null
  pop:  () -> elem
{% endhighlight %}

<svg id="canvas" class="canvas"></svg>
<script src="{{ '/assets/common.js' | prepend: site.baseurl }}"></script>
<script src="{{ '/assets/stack.js' | prepend: site.baseurl }}"></script>
