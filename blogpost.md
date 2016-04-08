Problem Solving in APL: Random Dungeon Generation
=================================================

Since I first started learning APL a few months back, I have become fascinated with the way that one approaches problems in the language. APL is a fairly old language, having been first introduced in the 1960's, that is fairly dissimilar from many modern programming languages. The language does not contain traditional flow control structures, does not have a large and robust standard library, and it does not lend itself well to solving all kinds of problems. What the language does provide, though, is a small but full set of array algebra operators and a principle design philosophy around composibility. The language uses mathematical and logical symbols in order to represent the operators and, as such, requires it's own keyboard layout. There are modern languages that are heavily inspired by APL that do not require special characters to type, such as J, but a significant amount of readability is lost in the transition to ascii character combinations.

In APL, functions are not called with a regular `f(x)` syntax that we are accustomed to. Instead, functions are always called like operators, either in their monadic form of `f x`, or their dyadic form of `y f x`. This restriction means that a function can only take in 1 or 2 arguments, no more, no less. It is normal in APL for a function's behaviour to change when it is called in it's monadic form vs. it's dyadic form.

As an example, one of the basic symbols in the language is the `⍴` symbol. In it's monadic form, ⍴ will return the shape of an array.

        ⍴ 1 1 1 1 1
    5

However, in it's dyadic form, ⍴ will reshape an array to a new specification.

        3 ⍴ 1 1 1 1 1
    1 1 1

Both of these behaviour's extend over to multidimensional arrays as well.

        3 3 ⍴ 5
    5 5 5
    5 5 5
    5 5 5

        3 3 ⍴ 1 2 3 4
    1 2 3
    4 1 2
    3 4 1

        ⍴ 3 3 ⍴ 0
    3 3

That last example there might be confusing at first, but in order to understand it, you only need to understand how APL evaluates code. APL evaluates expressions from right to left, so in that example, the `3 3 ⍴ 0` gets calculated first, giving us a 3x3 array of 0's. Then, ⍴ gets called in it's dyadic form with this array. This right to left evaluation rule is crucial to understanding APL code.

So, let's begin diving straight into the problem. We will go ahead and start with a base matrix b, which will just be a 0 filled matrix the same size as the our full dungeon map. I will start with something small so that the matrix is easier to read in the blog post.  Note that the `←` symbol is the assignment operator in APL.

        b ← 15 15 ⍴ 0

Now that we have our base array, let's write a function to select random points on this array, giving each point an equal probability of being selected. To do this, we will learn about the `?` (or "roll") function. Given a number, `?` will return a random number between 1 and that number.

        ? 10
    4
        ? 10
    3

Like the majority of provided functions in APL, the roll function will operator off of lists as well.

        ? 5 50 500 5000
    1 43 465 3539

So, in order to pick random points on the base matrix, we can generate a new matrix of the same size of the base matrix with 100 and then call roll on it in order to generate numbers from 1-100 for each point on the matrix. Then, we just need to compare each number generated in order to determine if that location is selected. Let's start with the random numbers.

        ? 15 15 ⍴ 100
    19 61 29 72 95  96 100  7 20 90 63 60 16 16 18
    24 74 23 13 88  52  44 98 28 27 22 44 23 84 20
    86 44 48 58  4  81   4  1 99 41 44 13 94 78 22
    30 21 58 70 29  20  51 22  9 34 46 22 84 91 74
    28 46 46 57 28  74  25 11 10 19 70 88 48 43 82
    35 62 13 23  4  64  67 18 30 51 23 73 79 83 19
    91 69 41 63 92  61  93 22 34 32 47 14 73 87 41
    47 31 55 87 36  75  88 70 55 31 46 97 18 57 50
    79 29 77  1 50  83  48 96 57 19 94 51 58 24 21
    95 93 49  9  1  29  13 57 91 51 63 36 29 54 98
    65 73  2 82 83 100  47  6 65 26 52 34 94 62 90
    48 10  8  2  8   2  56 17 53 18 38 40 65 46 55
    77 48 77 46 56  85  23 70  9 50 70 20 65 27 60
    46 35 42 57 18  61  51  6 56 67 18 87 65 30 26
    97 59 27 71 98  62  22 62 36 18 92 14 55 92 46

Now, let's apply a comparison to the array. For example, the following expression will give each location a 20% chance of being selected.

        20 ≥ ? 15 15 ⍴ 100
    0 0 0 0 0 1 0 0 1 0 0 1 0 1 1
    0 0 0 0 0 0 1 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 1 0 0 0 0 0 0 0 0
    0 0 0 0 0 1 0 0 0 0 1 1 1 0 0
    0 1 0 1 0 0 0 0 1 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 1 0 1 0 0 0
    0 0 0 1 0 0 0 0 0 0 0 1 1 1 0
    0 0 0 0 1 0 0 0 0 0 0 1 0 0 0
    0 0 0 0 0 0 0 0 0 1 0 1 0 0 0
    1 0 0 0 0 1 0 0 0 0 1 0 1 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 1 1
    0 0 0 1 1 0 0 0 0 0 0 0 0 0 0
    0 0 0 1 0 0 1 0 0 0 0 1 0 0 0
    0 0 0 0 0 0 1 0 1 0 0 0 1 1 0
    0 1 1 0 0 0 0 0 0 1 0 1 0 1 0

In the same way `?` applies to an array, comparisons can also apply to an array.

We can now abstract this out into a `randompoints` function rather easily. When defining functions in APL, two symbols `⍺` and `⍵` are used for the left and right arguments, respectively.

        randompoints ← {⍺≥?(⍴⍵)⍴100}
        5 randompoints b
    0 0 0 0 0 0 0 0 1 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 1 0 0 0 0 0
    0 0 0 0 1 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    1 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 0 0 0
    0 0 0 0 0 0 0 0 0 0 0 0 1 0 0

You will notice that the hard coded size of `b` was replaced with a call to get the shape of the right hand argument instead.
