import logo from "./logo.svg"
import "./App.css"
import { useEffect } from "react"
import { useState } from "react"

function App() {
    const [sendURL, setSendURL] = useState("")
    const [receiveURL, setReceiveURL] = useState("")
    const [loading, setLoading] = useState(false)

    const handleEnhance = () => {
        console.log("Fetching")
        fetch("https://412b-128-84-124-184.ngrok-free.app/process-video", {
            method: "POST",
            headers: {
                "Content-Type": "application/json",
            },
            body: JSON.stringify({ video_url: sendURL }),
        })
            .then((response) => response.json())
            .then((data) => {
                setReceiveURL(data.processed_video_url)
            })
            .catch((error) => {
                console.error("Error:", error)
            })
    }

    console.log(sendURL)
    console.log(receiveURL)

    return (
        <div className="flex flex-col items-center">
            <p className="text-zinc-800 text-5xl font-semibold tracking-tighter text-center mt-28">
                SHARP-AI-LY
            </p>
            <div>
                <div className="relative mt-10">
                    <input
                        type="search"
                        id="search"
                        className="block w-max p-4 text-sm text-gray-900 border border-gray-300 rounded-lg focus:border-transparent focus:ring-red-600 focus:outline-zinc-500"
                        placeholder="Enter a Youtube URL"
                        required
                        size={60}
                        autoComplete={"off"}
                        onChange={(event) => setSendURL(event.target.value)}
                        value={sendURL}
                    />
                    <button
                        type="submit"
                        className="text-white absolute end-2.5 bottom-2.5 bg-zinc-800 focus:ring-4 focus:outline-none focus:ring-blue-300 font-medium rounded-lg text-sm px-4 py-2"
                        onClick={() => {
                            setLoading(true)
                            handleEnhance()
                        }}
                    >
                        Enhance!
                    </button>
                </div>
            </div>
            {loading && (
                <svg
                    class="animate-spin h-5 w-5 mr-3 ..."
                    viewBox="0 0 24 24"
                ></svg>
            )}
            {receiveURL !== "" && (
                <video className="mt-30 shadow-sm" src={receiveURL}></video>
            )}
        </div>
    )
}

export default App
