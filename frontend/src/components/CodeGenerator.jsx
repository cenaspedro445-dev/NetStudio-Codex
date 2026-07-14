import { useState } from 'react'
import axios from 'axios'
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
      const response = await axios.post(
        'http://localhost:8000/generate',
        {
          prompt: prompt,
          model: selectedModel
        },
        {
          responseType: 'stream'
        }
      )

      let fullResponse = ''
      response.data.on('data', (chunk) => {
        const text = chunk.toString()
        fullResponse += text
        setResponse(fullResponse)
      })

      response.data.on('end', () => {
        setLoading(false)
      })

      response.data.on('error', (err) => {
        setError(`Error: ${err.message}`)
        setLoading(false)
      })
    } catch (error) {
      setError(`Error: ${error.response?.data?.detail || error.message}`)
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
