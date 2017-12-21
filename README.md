Project Planner
==============

A tool to plot project execution timelines in different formats. There are a few different logical components.

* Simulating execution using some model (like a single developer working).
* Mapping execution to a calendar (there's no use planning work on Christmas).
* Displaying the execution calendar in different formats.

## Example

    $ ruby cal.rb sample_projects_and_holidays.rb --gantt
    Projects, 2017-12-13, 2017-12-18, 2018-01-03, 2018-01-08, 2018-01-15, 2018-01-22, 2018-01-29, 2018-02-05, 2018-02-12
    Widget A, dev|design complete|dev ready, dev, launched, off, off, off, off, off, off
    Widget B, design complete, dev ready|dev, dev, dev|launched, off, off, off, off, off
    Redesign the website, off, design complete, dev ready, dev, dev, dev, launched, off, off
    Widget Q, off, off, off, off, design complete, dev ready|dev, dev, launched, off
    Widget C, off, off, off, off, off, design complete, dev ready|dev, dev, launched

    $ ruby cal.rb sample_projects_and_holidays.rb --weekly
    Week of 2017-12-13
    - Widget A (1d)
    - Widget B needs to be design complete on 2017-12-13
    Week of 2017-12-18
    - Widget A (3d)
    - Widget B needs to be dev ready on 2017-12-19
    - Redesign the website needs to be design complete on 2017-12-20
    - Widget B (1d)
    Week of 2018-01-03
    - Widget B (3d)
    - Widget A should be launched on 2018-01-04
    - Redesign the website needs to be dev ready on 2018-01-05
    Week of 2018-01-08
    - Widget B (1d)
    - Redesign the website (4d)
    - Widget B should be launched on 2018-01-11
    Week of 2018-01-15
    - Redesign the website (5d)
    - Widget Q needs to be design complete on 2018-01-17
    Week of 2018-01-22
    - Redesign the website (3d)
    - Widget Q needs to be dev ready on 2018-01-23
    - Widget Q (2d)
    - Widget C needs to be design complete on 2018-01-26
    Week of 2018-01-29
    - Widget Q (3d)
    - Redesign the website should be launched on 2018-01-30
    - Widget C needs to be dev ready on 2018-01-31
    - Widget C (2d)
    Week of 2018-02-05
    - Widget C (5d)
    - Widget Q should be launched on 2018-02-05
    Week of 2018-02-12
    - Widget C should be launched on 2018-02-14
