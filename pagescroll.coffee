transitioning = false
# For layouts with position:fixed header, add the height of the header here
height_fixed_header = 130
scroll = undefined
htmlElem = document.querySelector 'html'
links = document.querySelectorAll 'a[data-scroll="true"]'


getScrollTopElement = (e) ->
  top = height_fixed_header * -1
  while e.offsetParent? and e.offsetParent?
    top += e.offsetTop + ((if e.clientTop? then e.clientTop else 0))
    e = e.offsetParent
  top

  
getScrollTopDocument = ->
  scrollTopValue = undefined
  if window.pageYOffset isnt undefined then window.pageYOffset
  else
    if document.documentElement.scrollTop isnt undefined then document.documentElement.scrollTop
    else document.body.scrollTop



scrollHandler = (e) ->
  e.preventDefault()
  if transitioning is false
    transitioning = true
    hop_count = undefined
    getScrollTopDocumentAtBegin = undefined
    target = undefined
    href = undefined
    url = undefined
    id = undefined
    hash = undefined
    isClick = 'getAttribute' of this and @getAttribute('data-scroll')
    if window.location.pathname.replace(/^\//, '') is @pathname.replace(/^\//, '') and window.location.hostname is @hostname
      hash = @hash
      target = document.querySelector(hash)
      if target
        href = @attributes.href.value.toString()
        url = href.substr(0, href.indexOf('#'))
        if typeof document.body.style.transitionProperty is 'string'
          e.preventDefault()
          getScrollTopDocumentAtBegin = getScrollTopDocument()
          scroll = getScrollTopElement(target)
          
          # Change URL for modern browser
          window.history.pushState {}, `undefined`, url + @hash  if window.history and typeof window.history.pushState is 'function'
          htmlElem.className = hash.slice(1)
          htmlElem.style.marginTop = (getScrollTopDocumentAtBegin - scroll) + 'px'
          htmlElem.style.transition = '1s ease-in-out'
          htmlElem.setAttribute 'transitioning', transitioning
  return



# run the forEach on each article element
[].slice.call(links).forEach (el, i) ->
  el.addEventListener 'click', scrollHandler, false
  return

htmlElem.addEventListener 'transitionend', ((e) ->
  if @getAttribute('transitioning') is 'true'
    htmlElem.removeAttribute 'style'
    window.scrollTo 0, scroll
    transitioning = false
    @setAttribute 'transitioning', transitioning
    return
), false