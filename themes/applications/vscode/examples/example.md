<!-- See: https://learnxinyminutes.com/docs/markdown/-->

<!--This means we can use HTML elements in Markdown, such as the comment
element, and they won't be affected by a markdown parser. However, if you
create an HTML element in your markdown file, you cannot use markdown syntax
within that element's contents.-->

# This is an <h1>

## This is an <h2>

### This is an <h3>

#### This is an <h4>

##### This is an <h5>

###### This is an <h6>

_This text is in italics._
_And so is this text._

**This text is in bold.**
**And so is this text.**

**_This text is in both._**
**_As is this!_**
_**And this!**_

~~This text is rendered with strikethrough.~~

This is a paragraph. I'm typing in a paragraph isn't this fun?

Now I'm in paragraph 2.
I'm still in paragraph 2 too!

I'm in paragraph three!

I end with two spaces (highlight me to see them).

There's a <br /> above me!

> This is a block quote. You can either
> manually wrap your lines and put a `>` before every line or you can let your lines get really long and wrap on their own.
> It doesn't make a difference so long as they start with a `>`.

> You can also use more than one level
>
> > of indentation?
> > How neat is that?

- Item
- Item
- Another item

1. Item one
2. Item two
3. Item three

Boxes below without the 'x' are unchecked HTML checkboxes.

- [ ] First task to complete.
- [ ] Second task that needs done
      This checkbox below will be a checked HTML checkbox.
- [x] This task has been completed

---

    my_array.each do |item|
        puts item
    end

John didn't even know what the `go_to()` function did!

```ruby
def foobar
    puts "Hello world!"
end
```

---

[Click me!](http://test.com/)

[Click me!](http://test.com/ 'Link to Test.com')

[Click this link][link1] for more info about it!
[Also check out this link][foobar] if you want to.

[link1]: http://test.com/ 'Cool!'
[foobar]: http://foobar.biz/ 'Alright!'

[This][] is a link.

[this]: http://thisisalink.com/

![This is the alt-attribute for my image](http://imgur.com/myimage.jpg 'An optional title')

And reference style works as expected.

![This is the alt-attribute.][myimage]

[myimage]: relative/urls/cool/image.jpg "if you need a title, it's here"

<http://testwebsite.com/> is equivalent to
[http://testwebsite.com/](http://testwebsite.com/)

<foo@bar.com>

I want to type _this text surrounded by asterisks_ but I don't want it to be
in italics, so I do this: \*this text surrounded by asterisks\*.

Your computer crashed? Try sending a
<kbd>Ctrl</kbd>+<kbd>Alt</kbd>+<kbd>Del</kbd>

| Col1         |   Col2   |          Col3 |
| :----------- | :------: | ------------: |
| Left-aligned | Centered | Right-aligned |
| blah         |   blah   |          blah |

| Col 1               |  Col2   | Col3 |
| :------------------ | :-----: | ---: |
| Ugh this is so ugly | make it | stop |

<html>
  <head>
    <title>My Site</title>
  </head>
  <body>
    <h1>Hello, world!</h1>
    <a href="http://codepen.io/anon/pen/xwjLbZ">
      Come look at what this shows
    </a>
    <p>This is a paragraph.</p>
    <p>This is another paragraph.</p>
    <ul>
      <li>This is an item in a non-enumerated list (bullet list)</li>
      <li>This is another item</li>
      <li>And this is the last item on the list</li>
    </ul>
  </body>
</html>
