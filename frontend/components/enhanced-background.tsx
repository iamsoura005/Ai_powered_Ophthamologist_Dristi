"use client"

import { useEffect, useState } from "react"

interface FloatingParticle {
  id: number
  left: number
  top: number
  animationDelay: number
  animationDuration: number
}

export const EnhancedBackground = () => {
  const [particles, setParticles] = useState<FloatingParticle[]>([])
  const [mounted, setMounted] = useState(false)

  useEffect(() => {
    setMounted(true)
    
    // Generate particles only on client side
    const generatedParticles: FloatingParticle[] = []
    for (let i = 0; i < 20; i++) {
      generatedParticles.push({
        id: i,
        left: Math.random() * 100,
        top: Math.random() * 100,
        animationDelay: Math.random() * 3,
        animationDuration: 2 + Math.random() * 2,
      })
    }
    setParticles(generatedParticles)
  }, [])
  return (
    <div className="absolute inset-0 overflow-hidden">
      {/* Base dark background */}
      <div className="absolute inset-0 bg-[#0E0E10]" />

      {/* Animated glow effects */}
      <div className="absolute inset-0">
        <div className="absolute top-1/4 left-1/4 w-96 h-96 rounded-full bg-purple-500/20 mix-blend-screen filter blur-3xl opacity-50 animate-pulse" />
        <div className="absolute bottom-1/4 right-1/4 w-96 h-96 rounded-full bg-teal-400/20 mix-blend-screen filter blur-3xl opacity-50 animate-pulse delay-200" />
        <div className="absolute top-3/4 left-1/2 w-64 h-64 rounded-full bg-blue-500/15 mix-blend-screen filter blur-2xl opacity-40 animate-pulse delay-500" />
        <div className="absolute top-1/2 right-1/3 w-80 h-80 rounded-full bg-indigo-500/15 mix-blend-screen filter blur-3xl opacity-30 animate-pulse delay-700" />
      </div>

      {/* Subtle grid pattern overlay */}
      <div className="absolute inset-0 opacity-5">
        <div
          className="w-full h-full"
          style={{
            backgroundImage: `
              linear-gradient(rgba(255,255,255,0.1) 1px, transparent 1px),
              linear-gradient(90deg, rgba(255,255,255,0.1) 1px, transparent 1px)
            `,
            backgroundSize: "50px 50px",
          }}
        />
      </div>

      {/* Floating particles */}
      <div className="absolute inset-0">
        {mounted && particles.map((particle) => (
          <div
            key={particle.id}
            className="absolute w-1 h-1 bg-white/20 rounded-full animate-pulse"
            style={{
              left: `${particle.left}%`,
              top: `${particle.top}%`,
              animationDelay: `${particle.animationDelay}s`,
              animationDuration: `${particle.animationDuration}s`,
            }}
          />
        ))}
      </div>

      {/* Gradient overlays for depth */}
      <div className="absolute inset-0 bg-gradient-to-br from-purple-900/10 via-transparent to-teal-900/10" />
      <div className="absolute inset-0 bg-gradient-to-tr from-blue-900/5 via-transparent to-indigo-900/5" />
    </div>
  )
}
