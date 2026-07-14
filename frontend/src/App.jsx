import { useState, useEffect } from 'react'
import './App.css'
import CodeGenerator from './components/CodeGenerator'

function App() {
  const [status, setStatus] = useState('connecting')
  const [models, setModels] = useState([])

  useEffect(() => {
    checkBackendHealth()
    loadModels()
  }, [])

  const checkBackendHealth = async () => {
    try {
      const response = await fetch('http://localhost:8000/health')
      if (response.ok) {
        setStatus('connected')
      }
    } catch (error) {
      setStatus('disconnected')
    }
  }

  const loadModels = async () => {
    try {
      const response = await fetch('http://localhost:8000/ollama/models')
      const data = await response.json()
      setModels(data.models || [])
    } catch (error) {
      console.error('Failed to load models:', error)
    }
  }

  return (
    <div className="App">
      <header>
        <h1>NetStudio Codex</h1>
        <p>Status: <span className={status}>{status}</span></p>
      </header>
      <main>
        <CodeGenerator models={models} />
      </main>
    </div>
  )
}

export default App
