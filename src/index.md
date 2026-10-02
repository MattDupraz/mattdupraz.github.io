---
layout: main.html
---

<article id="about-me">

<h2 class="heading">
    <span class="icon info"></span>
    About me
</h2>

Hi! I am a PhD student at Freie Universität Berlin broadly interested in
interactions between algebraic geometry and combinatorics.
I started my PhD in
September 2024 under the supervision of 
[Christian Haase](https://www.mi.fu-berlin.de/en/math/groups/ag-diskret-algebra-geom/members/Professoren/christian_haase.html)
(FU Berlin) and
[Leonid Monin](https://people.epfl.ch/leonid.monin) (EPFL),
in the project
[K-Theory and Normal Complexes](https://combinatorial-synergies.de/projects/?elem=K-Theory-and-Normal-Complexes)
which is part of the 
[SPP Combinatorial Synergies](https://combinatorial-synergies.de/)
The goal of this project is to study Chow rings and K-rings of certain toric
varieties, with the aim of finding interesting combinatorial interpretations of
some computations in these rings.

More generally, I am interested in tropical geometry and algebraic combinatorics -
I enjoy studying interactions between objects such as matroids, hyperplane arrangements,
polytopes and objects from algebraic geometry.
</article>



<article id="research">

<h2 class="heading">
    <span class="icon research"></span>
    Research
</h2>

### Publications and Preprints

{%- for p in publications %}

- [{{ p.title }}]({{ p.url }}), with {{ p.coauthors }}, {{ p.status }}
{%- endfor %}

### Master's thesis

- [Tropical linear systems and the realizability problem](https://arxiv.org/abs/2506.21268),
    Master’s thesis, Ecole Polytechnique
    Federale de Lausanne, 2024 

</article>



<article id="activities">

<h2 class="heading">
    <span class="icon activities"></span>
    Activities
</h2>

<!--
### Villa Student Seminar

This is the weekly student seminar of the Discrete Geometry and Topological Combinatorics group of Freie Universität Berlin, organized by and for PhD and Masters students. We provide a supportive, friendly place for students to give talks on their current research or topics they are interested in. The environment also facilitates opportunities for students to practice speaking.

Topics of the talks vary depending on the interests of the speaker, mostly in the fields of discrete geometry, topology, and combinatorics.  Participants are expected to actively participate by asking questions and providing feedback, as well as give a talk or chair at least once per semester.

The seminar happens in person in the seminar room of the Villa
(Arnimallee 2). If you are interested in joining, feel free to subscribe to our
[mailing list](https://lists.fu-berlin.de/listinfo/villastudentseminar).
-->

### Research visits
{% render "_event_list.html", items: visits %}

### Organization
{% render "_event_list.html", items: organization %}

### Invited talks
{% render "_event_list.html", items: invitedTalks %}

### Contributed talks
{% render "_event_list.html", items: contributedTalks %}

### Attended conferences
{% render "_conference_list.html", items: conferences %}
</article>
