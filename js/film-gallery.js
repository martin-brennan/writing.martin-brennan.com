import PhotoSwipeLightbox from "/js/vendor/photoswipe-lightbox.esm.min.js";
import PhotoSwipe from "/js/vendor/photoswipe.esm.min.js";

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
