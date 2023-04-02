document.addEventListener("keyup", (event) => {
    if (event.code === "Slash" && (event.ctrlKey || event.metaKey)) {
        window.location.href = "/search";
    }
});
