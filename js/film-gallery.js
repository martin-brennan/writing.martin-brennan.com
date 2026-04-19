import PhotoSwipeLightbox from "/js/vendor/photoswipe-lightbox.esm.min.js";
import PhotoSwipe from "/js/vendor/photoswipe.esm.min.js";

// Masonry layout that orders items left-to-right, then top-to-bottom.
// Uses data-pswp-width/height to compute aspect ratios so layout
// doesn't depend on images being loaded (works with loading="lazy").
function layoutMasonry() {
  const container = document.querySelector(".film-masonry");
  if (!container) return;

  const items = Array.from(container.querySelectorAll(".film-masonry-item"));
  if (!items.length) return;

  const gap = 16;
  const containerWidth = container.offsetWidth;

  let cols;
  const viewportWidth = window.innerWidth;
  if (viewportWidth <= 500) cols = 1;
  else if (viewportWidth <= 1000) cols = 2;
  else cols = 3;

  const colWidth = (containerWidth - gap * (cols - 1)) / cols;
  const colHeights = new Array(cols).fill(0);

  items.forEach((item) => {
    // Find the shortest column
    const shortestCol = colHeights.indexOf(Math.min(...colHeights));

    const x = shortestCol * (colWidth + gap);
    const y = colHeights[shortestCol];

    item.style.left = x + "px";
    item.style.top = y + "px";
    item.style.width = colWidth + "px";

    // Compute height from known aspect ratio
    const w = parseInt(item.dataset.pswpWidth, 10);
    const h = parseInt(item.dataset.pswpHeight, 10);
    const imgHeight = w && h ? colWidth * (h / w) : item.offsetHeight;

    // Account for the caption overlay (no extra box height)
    colHeights[shortestCol] += imgHeight + gap;
  });

  container.style.height = Math.max(...colHeights) - gap + "px";
  container.classList.add("film-masonry-ready");
}

layoutMasonry();
window.addEventListener("resize", layoutMasonry);

// Fade in images as they load and remove the skeleton shimmer.
document.querySelectorAll(".film-masonry-item img").forEach((img) => {
  if (img.complete) {
    img.closest(".film-masonry-item").classList.add("loaded");
  } else {
    img.addEventListener("load", () => {
      img.closest(".film-masonry-item").classList.add("loaded");
    });
    img.addEventListener("error", () => {
      img.closest(".film-masonry-item").classList.add("loaded");
    });
  }
});

const lightbox = new PhotoSwipeLightbox({
  gallery: ".film-masonry",
  children: ".film-masonry-item",
  pswpModule: PhotoSwipe,

  // Show caption below image, tighter on mobile
  paddingFn: () => {
    const mobile = window.innerWidth < 700;
    return {
      top: mobile ? 10 : 40,
      bottom: mobile ? 80 : 120,
      left: mobile ? 15 : 70,
      right: mobile ? 15 : 70,
    };
  },
});

// Add caption support
lightbox.on("uiRegister", function () {
  lightbox.pswp.ui.registerElement({
    name: "caption",
    order: 9,
    isButton: false,
    appendTo: "root",
    onInit: (el) => {
      el.style.cssText =
        "position:absolute;bottom:0;left:0;right:0;padding:16px 20px;background:rgba(0,0,0,0.6);color:#fff;font-size:14px;line-height:1.5;text-align:center;";
      lightbox.pswp.on("change", () => {
        const slide = lightbox.pswp.currSlide;
        const item = slide.data.element;
        const title = item.querySelector(".film-caption-title").textContent;
        const desc = item.dataset.description || "";
        el.innerHTML = "<strong>" + title + "</strong><br>" + desc;
      });
    },
  });
});

lightbox.init();
