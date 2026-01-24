import EasyMDE from "easymde"

export default {
    mounted() {
        this.editor = new EasyMDE({
            element: this.el,
            forceSync: true, // Ensures textarea value updates automatically
            status: false,   // Hides status bar
            toolbar: ["bold", "italic", "heading", "|", "quote", "unordered-list", "ordered-list", "|", "link", "image", "|", "preview", "side-by-side", "fullscreen", "|", "guide"]
        })

        // Sync changes back to LiveView
        this.editor.codemirror.on("change", () => {
            this.el.value = this.editor.value()
            this.el.dispatchEvent(new Event("input", { bubbles: true }))
        })
    },
    destroyed() {
        if (this.editor) {
            this.editor.toTextArea()
            this.editor = null
        }
    }
}
