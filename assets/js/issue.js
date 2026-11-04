// Turns the newsletter's "- **Label:** value" list items into styled cards.
// The Markdown stays in the same format the slide-deck generator reads,
// so one file feeds both the website and the PowerPoint.
// Without JavaScript the page still reads fine as plain lists.
(function () {
  var body = document.querySelector(".issue-body");
  if (!body) return;
  var imageDir = document.querySelector(".issue").dataset.imageDir;

  // Section heading text -> CSS class (colors come from main.scss)
  var SECTIONS = {
    "quick scan": "quick-scan",
    "tool drop": "tool-drop",
    "the breakdown": "the-breakdown",
    "ed pulse": "ed-pulse",
    "in action": "in-action",
    "try this": "try-this",
    "follow-up": "whats-next"
  };

  // Field name in Markdown -> label shown to readers (null = not shown as text)
  var LABELS = {
    Teaser: null, Content: null, Intro: null,
    TheNews: "The news", MyTake: "My take", Analysis: "The breakdown",
    TheLesson: "The lesson", ThePrompt: "Try this prompt"
  };

  function sectionFor(text) {
    var t = text.toLowerCase();
    for (var key in SECTIONS) if (t.indexOf(key) === 0) return SECTIONS[key];
    return "extra";
  }

  function textOf(html) {
    var d = document.createElement("div");
    d.innerHTML = html;
    return d.textContent.trim();
  }

  function parseItem(li) {
    var parts = li.innerHTML.split(/<strong>([A-Za-z]+):<\/strong>/);
    if (parts.length < 3) return null; // not a "**Label:**" item
    var fields = {};
    for (var i = 1; i < parts.length; i += 2) fields[parts[i]] = parts[i + 1].trim();
    return fields.Title ? fields : null;
  }

  function buildCard(f) {
    var html = "<h3>" + f.Title + "</h3>";
    var img = f.ArticleImage || f.Image;
    if (img) {
      var src = /^https?:/.test(textOf(img)) ? textOf(img) : imageDir + textOf(img);
      var cap = f.ArticleImageCaption || f.Caption || "";
      html += '<figure><img src="' + src + '" alt="' + textOf(cap).replace(/"/g, "&quot;") +
              '" loading="lazy">' + (cap ? "<figcaption>" + cap + "</figcaption>" : "") + "</figure>";
    }
    Object.keys(f).forEach(function (k) {
      if (!(k in LABELS)) return;
      if (LABELS[k]) html += '<span class="label">' + LABELS[k] + "</span>";
      html += k === "ThePrompt" ? '<div class="prompt">' + f[k] + "</div>" : "<p>" + f[k] + "</p>";
    });
    if (f.URL) {
      html += '<a class="button" href="' + textOf(f.URL) + '" target="_blank" rel="noopener">' +
              (f.LinkText ? textOf(f.LinkText) : "Read more") + " →</a>";
    }
    return html;
  }

  var current = "extra";
  Array.prototype.forEach.call(body.children, function (el) {
    if (el.tagName === "H2") {
      // "## Follow-up heading: How can AI help me?" -> show just the question.
      var m = el.textContent.match(/^Follow-up heading[:\s]+(.+)/i);
      if (m) el.textContent = m[1];
      // "## Follow-up tasks" is only a marker for the slide generator.
      if (/^Follow-up tasks/i.test(el.textContent)) { el.hidden = true; return; }
      current = sectionFor(m ? "follow-up" : el.textContent);
      el.classList.add("section-" + current);
    } else if (el.tagName === "UL") {
      el.classList.add("section-" + current);
      var made = 0;
      Array.prototype.forEach.call(el.children, function (li) {
        var f = parseItem(li);
        if (f) { li.className = "card"; li.innerHTML = buildCard(f); made++; }
      });
      if (made) el.classList.add("cards");
    }
  });
})();
