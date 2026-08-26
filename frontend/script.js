// Theme toggle (remembers choice)
const root = document.documentElement;
const tg = document.getElementById("theme-toggle");
const saved = localStorage.getItem("theme");
if (saved) root.setAttribute("data-theme", saved);
function updateToggle() {
  const dark = root.getAttribute("data-theme") === "dark";
  if (tg) tg.textContent = dark ? "☀️" : "🌙";
}
updateToggle();
tg && tg.addEventListener("click", () => {
  const dark = root.getAttribute("data-theme") === "dark";
  const next = dark ? "light" : "dark";
  root.setAttribute("data-theme", next);
  localStorage.setItem("theme", next);
  updateToggle();
});

// Live visitor counter
fetch("https://lbrdh2bfu0.execute-api.eu-central-1.amazonaws.com/count")
  .then((r) => r.json())
  .then((d) => { const el = document.getElementById("vc"); if (el) el.textContent = d.count; })
  .catch(() => { const el = document.getElementById("vc"); if (el) el.textContent = "—"; });

// Contact form via Web3Forms
const form = document.getElementById("contact-form");
if (form) {
  form.addEventListener("submit", async (e) => {
    e.preventDefault();
    const status = document.getElementById("form-status");
    status.textContent = "Sending...";
    status.className = "form-status";
    try {
      const res = await fetch("https://api.web3forms.com/submit", {
        method: "POST",
        headers: { Accept: "application/json" },
        body: new FormData(form),
      });
      const data = await res.json();
      if (data.success) {
        status.textContent = "Thanks! Your message has been sent.";
        status.className = "form-status ok";
        form.reset();
      } else {
        status.textContent = "Something went wrong. Please email me directly.";
        status.className = "form-status err";
      }
    } catch (err) {
      status.textContent = "Something went wrong. Please email me directly.";
      status.className = "form-status err";
    }
  });
}