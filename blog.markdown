---
layout: page
title: Blog
permalink: /blog/
---

<div class="blog-posts">
  {% for post in site.posts %}
  <a href="{{ post.url | relative_url }}" class="post-card">
    <h2>{{ post.title }}</h2>
    <p class="post-meta">
      <time datetime="{{ post.date | datetime }}">{{ post.date | date: "%B %d, %Y" }}</time>
      {% if post.categories %} &middot; {{ post.categories | join: ", " }}{% endif %}
    </p>
    <p>{{ post.excerpt | strip_html | truncate: 200 }}</p>
  </a>
  {% endfor %}
  
  {% if site.posts.size == 0 %}
  <p style="text-align: center; color: var(--text-muted);">No posts yet. Check back soon!</p>
  {% endif %}
</div>
