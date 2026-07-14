import { useState, useEffect } from 'react'
import axios from 'axios'
import './App.css'
import CodeGenerator from './components/CodeGenerator'

function App() {
  const [status, setStatus] = useState('connecting')
  const [models, setModels] = useState([])
  const [ollamaAvailable, setOllamaAvailable] = useState(false)

  useEffect(() => {
    checkBackendHealth()
  }, [])

  const checkBackendHealth = async () => {
    try {
      const response = await axios.get('http://localhost:8000/health')
      const data = response.data
      
      setStatus('connected')
      setOllamaAvailable(data.ollama_available)
      setModels(data.models_available || [])
      
      if (!data.ollama_available) {
        console.warn('⚠️ Ollama not available')
      }
    } catch (error) {
      setStatus('disconnected')
      setOllamaAvailable(false)
      console.error('Backend connection failed:', error)
    }
  }

  return (
    <div className="App">
      <header>
        <h1>🧠 NetStudio Codex</h1>
        <div className="header-status">
          <span className={`status ${status}`}>Backend: {status}</span>
          <span className={`status ${ollamaAvailable ? 'connected' : 'disconnected'}`}>
            Ollama: {ollamaAvailable ? 'Ready' : 'Offline'}
          </span>
          {models.length > 0 && (
            <span className="status connected">Models: {models.length}</span>
          )}
        </div>
      </header>
      <main>
        <CodeGenerator models={models} ollamaAvailable={ollamaAvailable} />
      </main>
    </div>
  )
}

export default App
