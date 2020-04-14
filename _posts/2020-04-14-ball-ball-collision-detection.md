---
title: "Ball-Ball Collision Detection"
---

Let's say you want to create a physics simulation involving collisions. One way
to go about it is to set a time step, evolve the world for the given time step
and then check for any overlaps between different objects. The issue with this
approach is that you detect a collision **after** it happened, and this can lead
to some unpredictable behavior in a physics simulation. Another way to approach
this problem would be
to calculate the exact moment at which a collision would happen. So how do we do
that?

We'll have to simplify the problem to find a suitable solution. Let's suppose
there are two balls \\(A\\) and \\(B\\), with radii \\(r_A\\), \\(r_B\\),
initially at the positions \\(A_0\\), 
\\(B_0\\) and moving with a velocity given by \\(\vec{v_A}\\), \\(\vec{v_B}\\).
The question becomes: Will they collide? And when?

![figure](/assets/images/ball-01.svg "Fig. 1")

Figuring out if two balls overlap is not too hard -- if the distance between
their centers is inferior to \\(r_A + r_B\\), it means they must overlap. This
means that the balls collide when their distance from each other is exactly
\\(r_A + r_B\\). Let's label \\(A(t) = A_0 + \vec{v_A} \cdot t\\) and
\\(B(t) = B_0 + \vec{v_B} \cdot t\\) the positions of each ball after the time \\(t\\)
has elapsed. So the collision between the balls occurs at a certain time \\(t_c\\) iff
\\(\\|\overrightarrow{A(t_c)B(t_c)}\\| = r_A + r_B\\) in other words iff

\\[
	\\| \overrightarrow{A_0B_0} + (\vec{v_B} - \vec{v_A}) \cdot t_c \\| 
= r_A + r_B.
\\]

Let's denote \\(\vec{v_r} = \vec{v_B} - \vec{v_A}\\) the relative velocity of the balls, and \\(R = r_A + r_B\\) the sum of their radii. We can now write this in terms of the [inner product](https://en.wikipedia.org/wiki/Dot_product) to make the equation easier to manipulate,

\\[
	\langle \overrightarrow{A_0B_0} + \vec{v_r} \cdot t_c,
\overrightarrow{A_0B_0} + \vec{v_r} \cdot t_c \rangle
= R ^ 2.
\\]

Thanks to the [bilinearity](https://en.wikipedia.org/wiki/Bilinear_form) of the inner product we obtain

\\[
	\langle \overrightarrow{A_0B_0}, \overrightarrow{A_0B_0} \rangle + t_c^2 \cdot \langle \vec{v_r}, \vec{v_r} \rangle + 2 t_c \cdot \langle \overrightarrow{A_0B_0}, \vec{v_r} \rangle - R^2 = 0,
\\]

Which we can simplify to

\\[
	t_c^2 \\| \vec{v_r} \\|^2 + 2 t_c \cdot \langle \overrightarrow{A_0B_0}, \vec{v_r} \rangle + \\| \overrightarrow{A_0 B_0} \\|^2 - R^2 = 0.
\\]

We can now solve the quadratic equation to obtain \\(t_c\\)

\\[
	\Delta = 4 \langle \overrightarrow{A_0B_0}, \vec{v_r} \rangle ^ 2 + 4 R^2 \\| \vec{v_r} \\|^2 - 4 \\| \vec{v_r} \\|^2 \\| \overrightarrow{A_0B_0} \\|^2.
\\]

If \\(\Delta \leq 0\\), the balls won't collide, else the moment of their
collision is given by

\\[
	t_c = \frac{- 2 \cdot \langle \overrightarrow{A_0B_0}, \vec{v_r} \rangle \pm \sqrt{\Delta}}{2 \\|\vec{v_r}\\|^2}.
\\]

We're interested only in the lower value of t_c, since that's when the balls
come into contact -- the second value is when the balls stop overlapping, which
we are not interested in. Further simplifying gives us

\\[
	t_c = -\frac{\langle \overrightarrow{A_0B_0}, \vec{v_r} \rangle}{\langle \vec{v_r}, \vec{v_r} \rangle} - \sqrt{\frac{\langle \overrightarrow{A_0B_0}, \vec{v_r} \rangle ^ 2}{\langle \vec{v_r}, \vec{v_r} \rangle ^ 2} + \frac{R^2 - \langle \overrightarrow{A_0B_0}, \overrightarrow{A_0B_0} \rangle}{\langle \vec{v_r}, \vec{v_r} \rangle}}
\\]

Now all we have to do is check whether \\(t_c\\) is positive, and we're done!

![figure](/assets/images/ball-02.svg "Fig. 1")
