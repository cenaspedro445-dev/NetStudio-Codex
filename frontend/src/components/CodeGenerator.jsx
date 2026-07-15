import { useState } from 'react'
import '../styles/CodeGenerator.css'

function CodeGenerator({ models, ollamaAvailable }) {
  const [prompt, setPrompt] = useState('')
  const [response, setResponse] = useState('')
  const [loading, setLoading] = useState(false)
  const [selectedModel, setSelectedModel] = useState(models[0] || 'qwen2.5-coder')
  const [error, setError] = useState('')

  const handleGenerate = async () => {
    if (!prompt.trim()) {
      setError('Please enter a prompt')
      return
    }

    if (!ollamaAvailable) {
      setError('Ollama is not available. Make sure it\'s running on http://localhost:11434')
      return
    }

    setLoading(true)
    setResponse('')
    setError('')

    try {
      const response = await fetch('http://localhost:8000/generate', {
        method: 'POST',
        headers: {
          'Content-Type': 'application/json',
        },
        body: JSON.stringify({ prompt, model: selectedModel }),
      })

      if (!response.ok) {
        const error = await response.json()
        setError(`Error: ${error.detail || response.statusText}`)
        setLoading(false)
        return
      }

      const reader = response.body.getReader()
      const decoder = new TextDecoder()
      let fullResponse = ''

      try {
        while (true) {
          const { done, value } = await reader.read()
          if (done) break

          const chunk = decoder.decode(value, { stream: true })
          fullResponse += chunk
          setResponse(fullResponse)
        }
      } finally {
        reader.cancel()
      }

      setLoading(false)
    } catch (error) {
      setError(`Error: ${error.message}`)
      setLoading(false)
    }
  }

  return (
    <div className="code-generator">
      <div className="input-section">
        <div className="controls">
          <select
            value={selectedModel}
            onChange={(e) => setSelectedModel(e.target.value)}
            disabled={loading || models.length === 0}
            className="model-select"
          >
            {models.map((model) => (
              <option key={model} value={model}>
                {model}
              </option>
            ))}
          </select>
        </div>
        
        <textarea
          value={prompt}
          onChange={(e) => setPrompt(e.target.value)}
          placeholder="Enter your code prompt here...\n\nExample: Write a function to reverse a string in Python"
          disabled={loading || !ollamaAvailable}
          maxLength={10000}
          className="prompt-input"
        />
        
        <button 
          onClick={handleGenerate} 
          disabled={loading || !ollamaAvailable}
          className="generate-button"
        >
          {loading ? '⏳ Generating...' : '✨ Generate'}
        </button>
        
        {error && <div className="error-message">{error}</div>}
      </div>
      
      <div className="output-section">
        <h3>Generated Code</h3>
        <pre className="code-output">
          <code>{response || '⏳ Output will appear here...'}</code>
        </pre>
      </div>
    </div>
  )
}

export default CodeGenerator
