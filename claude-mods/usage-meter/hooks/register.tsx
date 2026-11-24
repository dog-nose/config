import { atom, read, update } from 'claude-code'
import type { Register } from 'claude-code'

import type { Limit } from '../types'

const limits = atom({ plugin: 'usage-meter', key: 'limits' } as const, [], { shape: 'limits-1' })

const LABELS: Record<string, string> = { five_hour: '5時間', seven_day: '週間' }

function bar(percent: number): string {
  const p = Math.max(0, Math.min(100, percent))
  const w = Math.max(p === 0 ? 0 : 6, p * 1.2)
  const color = p >= 85 ? '#f0645a' : p >= 60 ? '#f0b44a' : '#5fb0ff'

  return `<svg xmlns="http://www.w3.org/2000/svg" width="120" height="8" viewBox="0 0 120 8"><rect width="120" height="8" rx="4" fill="#ffffff" fill-opacity=".18"/><rect width="${w}" height="8" rx="4" fill="${color}"/></svg>`
}

function resets(iso?: string): string {
  if (iso === undefined) {
    return ''
  }
  const d = new Date(iso)

  return `リセット ${d.getMonth() + 1}/${d.getDate()} ${String(d.getHours()).padStart(2, '0')}:${String(d.getMinutes()).padStart(2, '0')}`
}

export const register: Register = on => {
  on('session.start', async ($, e, next) => {
    if (e.surface === 'desktop') {
      const usage = await $.session.usage()
      await update($, limits, () => usage.rateLimits.map(l => ({ ...l })) as Limit[])
    }

    return next(e)
  })

  on('session.measure', async ($, e, next) => {
    await update($, limits, () => e.rateLimits.map(l => ({ ...l })) as Limit[])

    return next(e)
  })

  on('ui.render', { component: 'AbovePrompt' }, async ($, e, next) => {
    if (e.surface !== 'desktop') {
      return next(e)
    }
    const { Box, Text, Svg } = $.ui.resolve(e)
    const list = await read($, limits)
    const rows = ['five_hour', 'seven_day']
      .map(k => list.find(l => l.kind === k))
      .filter((l): l is Limit => l !== undefined)

    if (rows.length === 0) {
      return next(e)
    }

    return (
      <Box flexDirection="row" gap={3}>
        {rows.map(l => (
          <Box flexDirection="row" gap={1} alignItems="center">
            <Text>{LABELS[l.kind] ?? l.kind}</Text>
            <Svg source={bar(l.percentUsed)} alt={`${l.percentUsed}%`} width={120} height={8} />
            <Text>{l.percentUsed}%</Text>
            <Text dimColor>{resets(l.resetsAt)}</Text>
          </Box>
        ))}
      </Box>
    )
  })
}
