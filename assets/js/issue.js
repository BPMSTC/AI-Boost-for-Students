// Adds a "Copy prompt" button to each prompt box so students can paste it into an AI tool.
// Without JavaScript the prompt still shows; students just select and copy it by hand.
(function () {
  document.querySelectorAll(".issue-body pre").forEach(function (pre) {
    if (!navigator.clipboard) return;
    var btn = document.createElement("button");
    btn.type = "button";
    btn.className = "copy";
    btn.textContent = "Copy prompt";
    btn.addEventListener("click", function () {
      navigator.clipboard.writeText(pre.innerText.trim()).then(function () {
        btn.textContent = "Copied!";
        setTimeout(function () { btn.textContent = "Copy prompt"; }, 2000);
      });
    });
    pre.insertAdjacentElement("afterend", btn);
  });
})();
